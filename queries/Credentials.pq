let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("Token", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Unit = _t, #"Access Token" = _t, #"Client Token" = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Unit", type text}, {"Access Token", type text}, {"Client Token", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Access Token", "AccessToken"}, {"Client Token", "ClientToken"}})
in
    #"Renamed Columns"