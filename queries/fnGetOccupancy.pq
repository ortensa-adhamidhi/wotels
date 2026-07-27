let
    fnGetOccupancy = (
        accessToken as text,
        clientToken as text,
        serviceId   as text,
        firstDayUtc as text,
        lastDayUtc  as text
    ) =>
    let
        url =
            "https://api.mews.com/api/connector/v1/services/getAvailability/2024-01-22",

        body =
            Text.ToBinary(
                "{
                    ""ClientToken"": """ & clientToken & """,
                    ""AccessToken"": """ & accessToken & """,
                    ""Client"": ""Your App"",
                    ""ServiceId"": """ & serviceId & """,
                    ""FirstTimeUnitStartUtc"": """ & firstDayUtc & """,
                    ""LastTimeUnitStartUtc"": """ & lastDayUtc & """,
                    ""Metrics"": [""UsableResources"", ""Occupied""]
                }"
            ),

        response =
            Json.Document(
                Web.Contents(url, [
                    Headers = [#"Content-Type" = "application/json"],
                    Content = body
                ])
            ),

        dates =
            try response[TimeUnitStartsUtc] otherwise {},

        categories =
            try response[ResourceCategoryAvailabilities] otherwise {},

        dayCount = List.Count(dates),

        result =
            List.Transform(
                List.Positions(dates),
                (i) =>
                    [
                        Date = dates{i},

                        AvailableRooms =
                            List.Sum(
                                List.Transform(
                                    categories,
                                    each try [Metrics][UsableResources]{i} otherwise 0
                                )
                            ),

                        OccupiedRooms =
                            List.Sum(
                                List.Transform(
                                    categories,
                                    each try [Metrics][Occupied]{i} otherwise 0
                            )
                        )
                    ]
            ),

        output =
            Table.FromRecords(result)

    in
        output
in
    fnGetOccupancy