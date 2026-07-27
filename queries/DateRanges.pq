let
    StartDate = #date(2026, 1, 1),
    EndDate   = #date(2026, 12, 31),

    DaysList =
        List.Dates(
            StartDate,
            Duration.Days(EndDate - StartDate) + 1,
            #duration(1,0,0,0)
        ),

    TableOut =
        Table.FromList(DaysList, Splitter.SplitByNothing(), {"Date"}),

    // Portugal DST dates for 2026
    DSTStart = Date.AddDays(Date.StartOfWeek(#date(2026, 3, 31), Day.Sunday) ,1),
    DSTEnd   = Date.AddDays(Date.StartOfWeek(#date(2026, 10, 31), Day.Sunday), 1),

    // Convert Portugal midnight to correct UTC time
    AddUtc =
        Table.AddColumn(
            TableOut,
            "TimeUnitStartUtc",
            each
                let
                    OffsetHours =
                        if [Date] >= DSTStart and [Date] < DSTEnd
                        then -1
                        else 0,

                    UtcDateTime =
                        #datetime(
                            Date.Year([Date]),
                            Date.Month([Date]),
                            Date.Day([Date]),
                            0,
                            0,
                            0
                        )
                        + #duration(0, OffsetHours, 0, 0)
                in
                    DateTime.ToText(UtcDateTime, "yyyy-MM-ddTHH:mm:ss") & "Z",
            type text
        ),

    Buffered = Table.Buffer(AddUtc)

in
    Buffered