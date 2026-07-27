let
    
    Source = Credentials,

    // For each property row, call services/getAll to get the ServiceId
    AddServices = Table.AddColumn(
        Source,
        "Services",
        each
            let
                url  = "https://api.mews.com/api/connector/v1/services/getAll",
                body = Text.ToBinary(
                    "{
                        ""ClientToken"": """ & [ClientToken] & """,
                        ""AccessToken"": """ & [AccessToken] & """,
                        ""Client"":      ""YourApp"",
                        ""ServiceType"": ""Bookable"",
                        ""Limitation"":  { ""Count"": 100 }
                    }"
                ),
                response = try Json.Document(
                    Web.Contents(url, [
                        Headers = [#"Content-Type" = "application/json"],
                        Content  = body
                    ])
                ) otherwise null,
                services = if response = null then {} else try response[Services] otherwise {},
                tbl = Table.FromList(services, Splitter.SplitByNothing(), {"Row"}),
                expanded = Table.ExpandRecordColumn(tbl, "Row",
                    {"Id", "Name", "IsActive"},
                    {"ServiceId", "ServiceName", "IsActive"}
                ),
                activeOnly = Table.SelectRows(expanded, each [IsActive] = true)
            in
                activeOnly
    ),

    // Expand so each active bookable service becomes its own row
    ExpandServices = Table.ExpandTableColumn(
        AddServices,
        "Services",
        {"ServiceId", "ServiceName", "IsActive"}
    ),

    // Drop IsActive (already filtered) and tidy up
    #"Removed Columns" = Table.RemoveColumns(ExpandServices, {"IsActive"}),

    #"Changed Type" = Table.TransformColumnTypes(
        #"Removed Columns",
        {{"Unit", type text}, {"ServiceId", type text}, {"ServiceName", type text}}
    )
in
    #"Changed Type"