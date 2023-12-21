# version: 1.0
#
# Example System.ps1 - IDM System PowerShell Script for demonstration and documentation purposes.
#
# Any IDM System PowerShell Script is dot-sourced in a separate PowerShell context, after
# dot-sourcing the IDM Generic PowerShell Script '../Generic.ps1'.
#


$Log_MaskableKeys = @(
    # Put a comma-separated list of attribute names here, whose value should be masked before 
    # writing to log files. Examples are:
    'Password',
    'accountPassword'
)


#
# System functions
#

function Idm-SystemInfo {
    param (
        # Operations
        [switch] $Connection,
        [switch] $TestConnection,
        [switch] $Configuration,
        # Parameters
        [string] $ConnectionParams
    )

    #
    # Idm-SystemInfo is a mandatory function. Each IDM system must implement this function, with 
    # the following functionality:
    #
    #  1) Idm-SystemInfo -Connection
    #
    #     Output an array of Parameter Items relevant to connect to the system. The concept of
    #     Parameter Items is described below.
    #
    #
    #  2) Idm-SystemInfo -TestConnection
    #                    -ConnectionParams <JSON-formatted string with Connection Parameters>
    #
    #     Test the connection specified by the -ConnectionParams argument. How <JSON-formatted 
    #     string with Connection Parameters> relates to the above Parameter Items is described 
    #     below.
    #
    #     On connection failure, an exception must be thrown. The output of this function is 
    #     ignored.
    #
    #
    #  3) Idm-SystemInfo -Configuration
    #                    -ConnectionParams <JSON-formatted string with Connection Parameters>
    #
    #     Output an array of Parameter Items relevant to configure data retrieval from the system,
    #     using the specified -ConnectionParams argument.
    #
    #
    # Paramerer Items
    # 
    #     Parameter Items is a recurring concept in IDM systems. Parameter Items describe the set 
    #     (array) of parameters needed to perform a cetrain task, e.g. connect to a system. 
    #     Parameter Items are fed to dynamic forms in the UI. Along with the metadata, Parameter 
    #     Items specify what configurable elements are shown in the UI and how. By filling out a 
    #     dynamic form, the user supplies values for each of the Parameter Items.
    #
    #     Values for the Parameter Items are passed to IDM functions in JSON format. This is best 
    #     explained by example. Suppose, a set of Parameter Items describes the parameters needed 
    #     to connect to a system. The following parameters are assumed to be relevant: system, 
    #     username and password. The set (array) of Parameter Items may look as follows:
    #
    #     @(
    #         @{
    #             name = 'system'
    #             type = 'textbox'
    #             ... more settings
    #         }
    #         @{
    #             name = 'username'
    #             type = 'textbox'
    #             ... more settings
    #         }
    #         @{
    #             name = 'password'
    #             type = 'textbox'
    #             password = $true
    #             ... more settings
    #         }
    #     )
    #
    #     If the values of these Parameter Items are passed to an IDM function, the JSON-formatted 
    #     string is structured as follows:
    #
    #     {
    #         "system":   <value from dynamic form>,
    #         "username": <value from dynamic form>,
    #         "password": <value from dynamic form>
    #     }
    #
    #     IDM functions must convert such JSON-formatted string to a PowerShell hashtable using 
    #     ConvertFrom-Json2, defined in the Generic PowerShell Script.
    #
    #     Parameter Items can be of type hastable, [ordered] hashtable, [PsObject] or 
    #     [PsCustomObject].
    #
    #     Specific details on Parameter Items are provided as examples in the functions below.
    #


    #
    # It's good practice to log invocation of each function.
    #

    Log info "-Connection=$Connection -TestConnection=$TestConnection -Configuration=$Configuration -ConnectionParams='$ConnectionParams'"
    
    if ($Connection) {
        #
        # Output an array of Parameter Items relevant to connect to the system.
        #

        @(
            #
            # Can be any combination of the following items:
            #

            @{
                name = 'text_item_name'
                type = 'text'
                text = 'Dispayed static text'
            }
            @{
                name = 'textbox_item_name'
                type = 'textbox'
                label = 'Display name (ŠρεϲίαƖ Ȼɦàґʂ) of textbox item'
                tooltip = 'Tooltip (ŠρεϲίαƖ Ȼɦàґʂ) of textbox item'
                value = 'Default value (ŠρεϲίαƖ Ȼɦàґʂ) of textbox item'
            }
            @{
                name = 'checkbox_item_name'
                type = 'checkbox'
                label = 'Display name of checkbox item'
                tooltip = 'Tooltip of checkbox item'
                value = $false                  # Default value of checkbox item
            }
            @{
                name = 'conditional_disabled_item_name'
                type = 'textbox'
                label = 'Display name of conditional disabled item'
                tooltip = 'Tooltip of conditional disabled item'
                value = 'Default value of conditional disabled item'
                disabled = 'checkbox_item_name'  # Appearance control
            }
            @{
                name = 'conditional_hidden_item_name'
                type = 'textbox'
                label = 'Display name of (indented) conditional hidden item'
                label_indent = $true            # Label indentation control
                tooltip = 'Tooltip of conditional hidden item'
                value = 'Default value of conditional hidden item'
                hidden = '!checkbox_item_name'  # Appearance control
            }
            @{
                name = 'password_textbox_item_name'
                type = 'textbox'
                password = $true                # Password control
                label = 'Display name of password textbox item'
                value = ''
                tooltip = 'Tooltip of password textbox item'
            }
            @{
                name = 'radio_item_name'
                type = 'radio'
                label = 'Display name of radio item'
                tooltip = 'Tooltip of radio item'
                table = @{
                    rows = @(
                        @{ id = 'id of radio entry 1'; display_text = 'Display text of radio entry 1' }
                        @{ id = 'id of radio entry 2'; display_text = 'Display text of radio entry 2' }
                        @{ id = 'id of radio entry 3'; display_text = 'Display text of radio entry 3' }
                    )
                    settings_radio = @{
                        value_column = 'id'
                        display_column = 'display_text'
                    }
                }
                value = 'id of radio entry 2'    # Default value of radio item
            }
            @{
                name = 'checkgroup_item_name'
                type = 'checkgroup'
                label = 'Display name of checkgroup item'
                tooltip = 'Tooltip of checkgroup item'
                table = @{
                    rows = @(
                        @{ id = 'id of checkgroup entry 1'; display_text = 'Display text of checkgroup entry 1' }
                        @{ id = 'id of checkgroup entry 2'; display_text = 'Display text of checkgroup entry 2' }
                        @{ id = 'id of checkgroup entry 3'; display_text = 'Display text of checkgroup entry 3' }
                    )
                    settings_checkgroup = @{
                        value_column = 'id'
                        display_column = 'display_text'
                    }
                }
                value = @('id of checkgroup entry 1', 'id of checkgroup entry 3')    # Default value of checkgroup item
            }
            @{
                name = 'date_item_name'
                type = 'date'
                label = 'Display name of date item'
                tooltip = 'Tooltip of date item'
                value = Get-Date -Format "yyyy-MM-dd"    # Default value of date item
            }
            @{
                name = 'combo_item_name'
                type = 'combo'
                label = 'Display name of combo item'
                tooltip = 'Tooltip of combo item'
                table = @{
                    rows = @(
                        @{ id = 'id of combo entry 1'; display_text = 'Display text of combo entry 1' }
                        @{ id = 'id of combo entry 2'; display_text = 'Display text of combo entry 2' }
                        @{ id = 'id of combo entry 3'; display_text = 'Display text of combo entry 3' }
                    )
                    settings_combo = @{
                        value_column = 'id'
                        display_column = 'display_text'
                    }
                }
                value = 'id of combo entry 2'    # Default value of combo item
            }
            @{
                name = 'grid_item_name'
                type = 'grid'
                label = 'Display name of grid item'
                tooltip = 'Tooltip of grid item'
                table = @{
                    rows = @(
                        @{ column_A = 'Value of cell A1'; column_B = 'Value of cell B1'; column_C = 'Value of cell C1' }
                        @{ column_A = 'Value of cell A2'; column_B = 'Value of cell B2'; column_C = 'Value of cell C2' }
                    )
                    settings_grid = @{
                        selection = 'multiple'   # Selection capability control; alternative: 'single' (default)
                        key_column = 'column_A'
                        checkbox = $true         # Checkbox control
                        filter = $true           # Enabled search filter
                        columns = @(
                            @{ name = 'column_A'; display_name = 'Display name of column_A' }
                            @{ name = 'column_B'; display_name = 'Display name of column_B' }
                            @{ name = 'column_C'; display_name = 'Display name of column_C' }
                        )
                    }
                }
                value = @('Value of cell A1')    # Default value of grid item
            }


            #
            # The following items have special meaning. Their names are reserved and defined by
            # convention. If omitted, the default values are:
            #
            # nr_of_sessions = 1
            # sessions_idle_timeout = 0 (off)
            #

            @{
                name = 'nr_of_sessions'
                type = 'textbox'
                label = 'Max. number of simultaneous sessions'
                value = 5
            }
            @{
                name = 'sessions_idle_timeout'
                type = 'textbox'
                label = 'Session cleanup idle time (minutes)'
                tooltip = '0 disables session cleanup'
                value = 30
            }
        )
    }

    if ($TestConnection) {
        #
        # Test the connection specified by the -ConnectionParams argument. On connection failure,
        # an exception must be thrown.
        #

        #
        # In case of Active Directory, this can be implemented as:
        #
        # $connection_params = ConvertSystemParams -Connection $ConnectionParams
        # Get-ADObject-ADSI @connection_params -LDAPFilter '*' -ResultSetSize 1 1>$null
        #
    }

    if ($Configuration) {
        #
        # Output an array of Parameter Items relevant to configure data exchange with the system,
        # using the specified -ConnectionParams argument.
        #

        @(
            #
            # Can be any combination of Parameter Items described previously.
            #

            @{
                name = 'some_system_configuration_item_name'
                type = 'textbox'
                label = 'Display name of some system configuration item'
                tooltip = 'Tooltip of some system configuration item'
                value = 'Default value of some system configuration item'
            }
        )
    }

    Log info "Done"
}


function Idm-OnUnload {
    #
    # Idm-OnUnload is an optional function. If exists, it will be called by the IDM service when 
    # unloading the PowerShell context. This is useful, for example, to close any open sessions 
    # to a system.
    #
}


#
# Object CRUD functions
#

function Idm-MyClassRead {
    param (
        # Mode
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    #
    # Any function that matches the pattern 'Idm-*Read' is automatically treated as a class 
    # source. The name of the class source is the function name part that matches the asterisk. 
    # Class source functions must implement the following functionality:
    #
    #  1) Idm-MyClassRead -GetMeta
    #                     -SystemParams <JSON-formatted string with System Parameters>
    #
    #     Output an array of Parameter Items relevant to configure data retrieval from the class,
    #     using the specified -SystemParams argument. The SystemParams argument is a concatenation 
    #     of Connection Parameters and Configuration Parameters obtained via calls to 
    #     Idm-SystemInfo.
    #
    #     Parameter Items must be of type hastable, [ordered] hash table, [PsObject] or 
    #     [PsCustomObject].
    #
    #
    #  2) Idm-MyClassRead -SystemParams   <JSON-formatted string with System Parameters>
    #                     -FunctionParams <JSON-formatted string with Function Parameters>
    #
    #     Output the requested Class Data, using the specified -SystemParams argument and 
    #     -FunctionParams argument.
    #
    #     In case of a memberships class read, at least two columns must be generated: one with an 
    #     id of the group/parent and one with the id of the member/child.
    #
    #     Class Data must allow conversion with ConvertTo-Csv. To enable object pipelining, avoid 
    #     intermediate storage of large sets of Class Data in object variables.
    #


    #
    # It's good practice to log invocation of each function.
    #

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {
        #
        # Output an array of Parameter Items relevant to configure data retrieval from the class,
        # using the specified -SystemParams argument.
        #

        @(
            #
            # Can be any combination of Parameter Items described previously.
            #

            @{
                name = 'some_class_configuration_item_name'
                type = 'textbox'
                label = 'Display name of some class configuration item'
                tooltip = 'Tooltip of some class configuration item'
                value = 'Default value of some class configuration item'
            }
        )
    }
    else {
        #
        # Output the requested Class Data, using the specified -SystemParams argument and 
        # -FunctionParams argument.
        #

        #
        # As an example, the contents of the specified -SystemParams argument and -FunctionParams 
        # argument is returned as Class Data.
        #

        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $output  = @( [PSCustomObject]@{ Name = '*** SystemParams ***'; Value = '' } )
        $output += @( $system_params.Keys   | ForEach-Object { [PSCustomObject]@{ Name = "$_"; Value = ConvertTo-Json -Compress -Depth 32 $system_params[$_]   } } )
        $output += @( [PSCustomObject]@{ Name = '*** FunctionParams (of MyClass) ***';  Value = '' } )
        $output += @( $function_params.Keys | ForEach-Object { [PSCustomObject]@{ Name = "$_"; Value = ConvertTo-Json -Compress -Depth 32 $function_params[$_] } } )

        $output
    }

    Log info "Done"
}


function Idm-UsersRead {
    param (
        # Mode
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    #
    # This is an example function
    #

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {
        #
        # Output an array of Parameter Items relevant to configure data retrieval from the class,
        # using the specified -SystemParams argument.
        #

        @()
    }
    else {
        #
        # Output the requested Class Data, using the specified -SystemParams argument and 
        # -FunctionParams argument.
        #

        @(
            [PSCustomObject]@{ user_id = '120634751'; user_name = 'Special Chars';   text = 'ŠρεϲίαƖ Ȼɦàґʂ' }
            [PSCustomObject]@{ user_id = '157120163'; user_name = 'Single Quote';    text = "'" }
            [PSCustomObject]@{ user_id = '151579232'; user_name = 'Double Quote';    text = '"' }
            [PSCustomObject]@{ user_id = '190196691'; user_name = 'Back Slash';      text = '\' }
            [PSCustomObject]@{ user_id = '173875528'; user_name = 'Field Delimiter'; text = ',' }
            [PSCustomObject]@{ user_id = '199670219'; user_name = 'Carriage Return'; text = "`r" }
            [PSCustomObject]@{ user_id = '107820759'; user_name = 'Line Feed';       text = "`n" }
            [PSCustomObject]@{ user_id = '107820759'; user_name = 'Horizontal Tab';  text = "`t" }
            [PSCustomObject]@{ user_id = '121087413'; user_name = 'Empty Field';     text = '' }
            [PSCustomObject]@{ user_id = '133910122'; user_name = 'Null Value';      test = $null }
        )
    }

    Log info "Done"
}


function Idm-GroupsRead {
    param (
        # Mode
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    #
    # This is an example function
    #

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {
        #
        # Output an array of Parameter Items relevant to configure data retrieval from the class,
        # using the specified -SystemParams argument.
        #

        @()
    }
    else {
        #
        # Output the requested Class Data, using the specified -SystemParams argument and 
        # -FunctionParams argument.
        #

        @(
            [PSCustomObject]@{ group_id = '350407628'; group_name = 'Administration' }
            [PSCustomObject]@{ group_id = '302555182'; group_name = 'Development'    }
            [PSCustomObject]@{ group_id = '398644355'; group_name = 'Finance'        }
            [PSCustomObject]@{ group_id = '349651494'; group_name = 'Sales'          }
        )
    }

    Log info "Done"
}


function Idm-MembershipsRead {
    param (
        # Mode
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    #
    # This is an example function
    #

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {
        #
        # Output an array of Parameter Items relevant to configure data retrieval from the class,
        # using the specified -SystemParams argument.
        #

        @()
    }
    else {
        #
        # Output the requested Class Data, using the specified -SystemParams argument and 
        # -FunctionParams argument.
        #

        @(
            [PSCustomObject]@{ group_id = '350407628'; user_id = '173875528' }
            [PSCustomObject]@{ group_id = '350407628'; user_id = '157120163' }
            [PSCustomObject]@{ group_id = '350407628'; user_id = '151579232' }
            [PSCustomObject]@{ group_id = '350407628'; user_id = '190196691' }
            [PSCustomObject]@{ group_id = '302555182'; user_id = '151579232' }
            [PSCustomObject]@{ group_id = '302555182'; user_id = '190196691' }
            [PSCustomObject]@{ group_id = '302555182'; user_id = '120634751' }
            [PSCustomObject]@{ group_id = '398644355'; user_id = '120634751' }
            [PSCustomObject]@{ group_id = '398644355'; user_id = '133910122' }
            [PSCustomObject]@{ group_id = '349651494'; user_id = '195870502' }
        )
    }

    Log info "Done"
}


function Idm-MyClassMyOperation {
    param (
        # Mode
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    #
    # Any function that matches the pattern 'Idm-*' and not matches the pattern 'Idm-*Read' and is 
    # not one of the reserved System functions, is automatically treated as a class operation. The 
    # name of the class operation is the function name part that matches the asterisk. Class 
    # operation functions must implement the following functionality:
    #
    #  1) Idm-MyClassMyOperation -GetMeta
    #                            -SystemParams <JSON-formatted string with System Parameters>
    #
    #     Output a structure (hashtable) that describes the semantics of the function and 
    #     allowance of function parameters. The structure must conform to one of the following 
    #     specifications:
    #
    #     A)
    #
    #     @{
    #         semantics = 'create'|'update'|'delete'
    #         parameters = @(
    #            @{ name = <parameter-name>; allowance = 'mandatory'|'prohibited'|'optional' }
    #            ...
    #            @{ name = '*';              allowance = 'mandatory'|'prohibited'|'optional' }
    #         )
    #     }
    #
    #     In this specification, the 'semantics' field specifies the CUD semantics of the 
    #     operation. The 'parameters' array specifies the allowance per parameter. Parameter name 
    #     '*' means all other parameters. Unless specified otherwise, all other parameters have
    #     'optional' allowance.
    #
    #     B)
    #
    #     @{
    #         semantics = 'memberships-update'
    #         parentTable = <parent-class-name>
    #     }
    #
    #     In this specification, the 'semantics' must be set as described to indicate the update
    #     functionality of a memberships class, whose parent class name is specified by the 
    #     'parentTable' field. The 'parameters' array is omitted and implies the following 
    #     specification:
    #
    #         parameters = @(
    #            @{ name = 'group';  allowance = 'mandatory'  }
    #            @{ name = 'add';    allowance = 'mandatory'  }
    #            @{ name = 'remove'; allowance = 'mandatory'  }
    #            @{ name = '*';      allowance = 'prohibited' }
    #         )
    #
    #     This means that in subsequent execution calls to this function (see 2 below), the 
    #     FunctionParams argument is expected to contain the following three parameters:
    #
    #         group:  id/key of the group/parent object to be updated
    #
    #         add:    array of ids/keys of the member/child object to be added to the group/parent
    #
    #         remove: array of ids/keys of the member/child object to be removed from the 
    #                 group/parent
    #
    #
    #  2) Idm-MyClassMyOperation -SystemParams   <JSON-formatted string with System Parameters>
    #                            -FunctionParams <JSON-formatted string with Function Parameters>
    #
    #     Perform the operation as described by the function semantics, using the specified 
    #     -SystemParams argument and -FunctionParams argument.
    #
    #     On operation failure, an exception must be thrown. The output of the function is 
    #     ignored.
    #


    #
    # It's good practice to log invocation of each function.
    #

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {
        #
        # Output a structure (hashtable) that describes the semantics of the function and 
        # allowance of function parameters.
        #

        # @{
        #     semantics = 'create' #|'update'|'delete'
        #     parameters = @(
        #         @{ name = 'id';   allowance = 'prohibited' }
        #         @{ name = 'name'; allowance = 'mandatory'  }
        #         @{ name = '*';    allowance = 'optional'   }
        #     )
        # }

        # Or

        # @{
        #     semantics = 'memberships-update'
        #     parentTable = 'Groups'
        # }
    }
    else {
        #
        # Perform the operation as described by the function semantics, using the specified 
        # -SystemParams argument and -FunctionParams argument.
        #

        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        #
        # In case of 'memberships-update' semantics, it's good practice to force 'add' and 
        # 'remove' fields to be arrays:
        #

        $function_params.add    = @( $function_params.add )
        $function_params.remove = @( $function_params.remove )

        # Perform operation here...
    }

    Log info "Done"
}


function Idm-Dispatcher {
    param (
        # Optional Class/Operation
        [string] $Class,
        [string] $Operation,
        # Mode
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    #
    # Idm-Dispatcher is a special (and optional) function, used in cases where class sources and 
    # operations are not known in advance, but determined runtime. If present, this function must 
    # have the following functionality:
    #
    #  1) Idm-Dispatcher -GetMeta
    #                    -SystemParams <JSON-formatted string with System Parameters>
    #
    #     Output a list (array) of available classes and supported operations per class. This is 
    #     a non-normalized array the following elements:
    #
    #     @{
    #         Class = <class-name>
    #         Operation = <operation-name>
    #         <optional fields to be shown in the UI>...
    #     }
    #
    #
    #  2) Idm-Dispatcher -Class 'MyClass'
    #                    -Operation 'MyOperation'
    #                    -GetMeta
    #                    -SystemParams <JSON-formatted string with System Parameters>
    #
    #  and/or
    #
    #  3) Idm-Dispatcher -Class 'MyClass'
    #                    -Operation 'MyOperation'
    #                    -SystemParams   <JSON-formatted string with System Parameters>
    #                    -FunctionParams <JSON-formatted string with Function Parameters>
    #
    #     Performs an operation identical to the description of Idm-MyClassMyOperation and 
    #     Idm-MyClassRead above.
    #


    #
    # It's good practice to log invocation of each function.
    #

    Log info "-Class='$Class' -Operation='$Operation' -GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($Class -eq '') {

        if ($GetMeta) {
            #
            # Output a list (array) of available classes and supported operations per class.
            #

            @(
                @{
                    Class = 'MyClass-1'
                    Operation = 'Read'
                    OptionalField = 'Some text'
                }
                @{
                    Class = 'MyClass-2'
                    Operation = 'Read'
                }
                @{
                    Class = 'MyClass-3'
                    Operation = 'Read'
                    AnotherOptionalField = 'Some other text'
                }
            )
        }
        else {
            # Purposely no-operation.
        }

    }
    else {

        if ($GetMeta) {

            if ($Operation -eq 'Read') {
                #
                # Output an array of Parameter Items relevant to configure data retrieval from the 
                # class, using the specified -SystemParams argument.
                #

                @(
                    #
                    # Can be any combination of Parameter Items described previously.
                    #

                    @{
                        name = "class_$($Class.Replace(' ','-'))_configuration_item_name"
                        type = 'textbox'
                        label = "Display name of class $($Class)'s configuration item"
                        tooltip = "Tooltip of class $($Class)'s configuration item"
                        value = "Default value of class $($Class)'s configuration item"
                    }
                )
            }
            else {
                #
                # Output a structure (hashtable) that describes the semantics of the function and 
                # allowance of function parameters.
                #
            }

        }
        else {

            if ($Operation -eq 'Read') {
                #
                # Output the requested Class Data, using the specified -SystemParams argument and 
                # -FunctionParams argument.
                #

                #
                # As an example, the contents of the specified -SystemParams argument and 
                # -FunctionParams argument is returned as Class Data.
                #

                $system_params   = ConvertFrom-Json2 $SystemParams
                $function_params = ConvertFrom-Json2 $FunctionParams

                $output  = @( [PSCustomObject]@{ Name = '*** SystemParams ***'; Value = '' } )
                $output += @( $system_params.Keys   | ForEach-Object { [PSCustomObject]@{ Name = "$_"; Value = ConvertTo-Json -Compress -Depth 32 $system_params[$_]   } } )
                $output += @( [PSCustomObject]@{ Name = "*** FunctionParams (of class $($Class)) ***";  Value = '' } )
                $output += @( $function_params.Keys | ForEach-Object { [PSCustomObject]@{ Name = "$_"; Value = ConvertTo-Json -Compress -Depth 32 $function_params[$_] } } )

                $output
            }
            else {
                #
                # Perform the operation as described by the function semantics, using the specified 
                # -SystemParams argument and -FunctionParams argument.
                #

                $system_params   = ConvertFrom-Json2 $SystemParams
                $function_params = ConvertFrom-Json2 $FunctionParams

                #
                # In case of 'memberships-update' semantics, it's good practice to force 'add' and 
                # 'remove' fields to be arrays:
                #

                $function_params.add    = @( $function_params.add )
                $function_params.remove = @( $function_params.remove )

                # Perform operation here...
            }

        }

    }

    Log info "Done"
}
