# Source: https://stackoverflow.com/questions/28593471/how-to-simplify-aws-dynamodb-query-json-output-from-the-command-line
def decode_ddb:
    def _sprop($key): select(keys == [$key])[$key];                 # single property objects only
       ((objects | { value: _sprop("S") })                          # string (from string)
    // (objects | { value: _sprop("NULL") | null })                 # null (from boolean)
    // (objects | { value: _sprop("B") })                           # blob (from string)
    // (objects | { value: _sprop("N") | tonumber })                # number (from string)
    // (objects | { value: _sprop("BOOL") })                        # boolean (from boolean)
    // (objects | { value: _sprop("M") | map_values(decode_ddb) })  # map (from object)
    // (objects | { value: _sprop("L") | map(decode_ddb) })         # list (from encoded array)
    // (objects | { value: _sprop("SS") })                          # string set (from string array)
    // (objects | { value: _sprop("NS") | map(tonumber) })          # number set (from string array)
    // (objects | { value: _sprop("BS") })                          # blob set (from string array)
    // (objects | { value: map_values(decode_ddb) })                # all other non-conforming objects
    // (arrays | { value: map(decode_ddb) })                        # all other non-conforming arrays
    // { value: . }).value                                          # everything else
    ;
