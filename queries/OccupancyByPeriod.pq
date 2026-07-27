let
    Source = Properties,

    Dates = DateRanges,
    BufferedDates = Table.Buffer(Dates),

    CrossJoin =
        Table.AddColumn(
            Source,
            "Dates",
            each BufferedDates
        ),

    ExpandDates =
        Table.ExpandTableColumn(
            CrossJoin,
            "Dates",
            {"Date", "TimeUnitStartUtc"}
        ),

    AddData =
        Table.AddColumn(
            ExpandDates,
            "DailyData",
            each try fnGetOccupancy(
                [AccessToken],
                [ClientToken],
                [ServiceId],
                [TimeUnitStartUtc],
                [TimeUnitStartUtc]
            ) otherwise null
        ),

    Expanded =
        Table.ExpandTableColumn(
            AddData,
            "DailyData",
            {"AvailableRooms", "OccupiedRooms"}
        ),

    Clean =
        Table.RemoveColumns(
            Expanded,
            {"AccessToken", "ClientToken", "ServiceId", "TimeUnitStartUtc"}
        ),

    Types =
        Table.TransformColumnTypes(
            Clean,
            {
                {"Date", type date},
                {"AvailableRooms", Int64.Type},
                {"OccupiedRooms", Int64.Type}
            }
        ),

    AddRate =
        Table.AddColumn(
            Types,
            "OccupancyRate",
            each
                if [AvailableRooms] = null or [AvailableRooms] = 0
                then null
                else [OccupiedRooms] / [AvailableRooms],
            Percentage.Type
        )
in
    AddRate