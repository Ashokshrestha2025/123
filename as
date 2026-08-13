HTML_Org_final = 
VAR _fallbackAvatar = "https://cdn-icons-png.flaticon.com/512/149/149071.png"

VAR _css = "
<style>
    .org-tree, .org-tree ul, .org-tree li { margin: 0; padding: 0; list-style: none; }
    .org-tree ul { padding-top: 25px; position: relative; display: flex; justify-content: center; }
    .org-tree li { text-align: center; position: relative; padding: 25px 8px 0 8px; }

    /* Tree Lines */
    .org-tree li::before, .org-tree li::after { content: ''; position: absolute; top: 0; right: 50%; border-top: 2px solid #b1b1b1; width: 50%; height: 25px; }
    .org-tree li::after { right: auto; left: 50%; border-left: 2px solid #b1b1b1; }
    .org-tree li:only-child::after, .org-tree li:only-child::before { display: none; }
    .org-tree li:only-child { padding-top: 0; }
    .org-tree li:first-child::before, .org-tree li:last-child::after { border: 0 none; }
    .org-tree li:last-child::before { border-right: 2px solid #b1b1b1; border-radius: 0 6px 0 0; }
    .org-tree li:first-child::after { border-radius: 6px 0 0 0; }
    .org-tree ul ul::before { content: ''; position: absolute; top: 0; left: 50%; border-left: 2px solid #b1b1b1; width: 0; height: 25px; }

    /* Last-tier vertical stack */
    .org-tree ul.vertical-stack { position: relative; display: block; padding-top: 15px; }
    .org-tree ul.vertical-stack::before {
        content: ''; position: absolute; top: 0; left: 50%; width: 0; height: 100%;
        border-left: 2px solid #b1b1b1; z-index: 0;
    }
    .org-tree ul.vertical-stack li { display: block; padding: 15px 0 0 0; position: relative; z-index: 1; }
    .org-tree ul.vertical-stack li::before,
    .org-tree ul.vertical-stack li::after { content: none; display: none; border: none; }

    /* Scroll pane */
    .chart-zoom-container{
        position:relative;
        width:100%;
        height:100%;
        overflow:auto;
        background:#fafafa;
        display:flex;
    }

    .org-tree-wrapper{
        display:inline-block;
        margin:auto;
        padding:30px;
        width:max-content;
        transform-origin: center center;
        transition: transform 0.08s ease-out;
    }

    /* Base Node Card */
    .org-node {
        border: 1px solid #c8c8c8; padding: 14px; text-decoration: none; color: #333;
        font-family: 'Segoe UI', Arial, sans-serif; display: inline-flex; align-items: center; gap: 14px;
        border-radius: 10px; background-color: #ffffff; box-shadow: 0px 3px 8px rgba(0,0,0,0.08);
        width: 260px; text-align: left; position: relative; cursor: pointer; transition: all 0.2s;
    }
    .org-node:hover { border-color: #0078d4; box-shadow: 0px 6px 14px rgba(0,120,212,0.18); }
    .org-avatar { width: 52px; height: 52px; border-radius: 50%; object-fit: cover; border: 2px solid #eaeaea; flex-shrink: 0; }
    .org-info { display: flex; flex-direction: column; width: 100%; }

    /* Job Title & Name */
    .org-node .title { color: #0078d4; font-weight: 700; font-size: 12px; line-height: 1.2; }
    .org-node .name { font-weight: 600; color: #111111; font-size: 14px; margin-top: 2px; }

    /* Hover Box Panel */
    .hover-panel {
        position: absolute; bottom: 105%; top: auto; left: 50%; transform: translateX(-50%) translateY(-10px);
        width: 320px; background-color: #ffffff; border: 1px solid #0078d4; border-radius: 12px;
        box-shadow: 0px 10px 30px rgba(0, 0, 0, 0.18); padding: 16px; opacity: 0; visibility: hidden;
        pointer-events: none; transition: all 0.25s ease; z-index: 99999; text-align: left;
    }
    .org-node:hover .hover-panel { opacity: 1; visibility: visible; transform: translateX(-50%) translateY(0px); }
    .panel-header { font-size: 11px; text-transform: uppercase; letter-spacing: 0.8px; color: #0078d4; font-weight: 700; border-bottom: 2px solid #f4f4f4; padding-bottom: 6px; margin-bottom: 12px; }
    .panel-row { display: flex; justify-content: space-between; font-size: 12px; padding: 6px 0; border-bottom: 1px solid #f9f9f9; }
    .panel-row:last-child { border-bottom: none; }
    .label { color: #707070; font-weight: 500; }
    .value { color: #202020; font-weight: 600; text-align: right; }

    /* Toggle Details / Summary */
    .org-tree summary { display: block; list-style: none; cursor: pointer; }
    .org-tree summary::-webkit-details-marker { display: none; }
    .org-tree summary::marker { content: ''; }

    .toggle-btn {
        position: absolute; bottom: -11px; left: 50%; transform: translateX(-50%);
        width: 22px; height: 22px; border-radius: 50%; border: 2px solid #ffffff;
        background: #0078d4; color: #ffffff; font-size: 14px; line-height: 1;
        display: flex; align-items: center; justify-content: center;
        box-shadow: 0 2px 5px rgba(0,0,0,.25); z-index: 20;
    }
    .toggle-btn::before { content: '\2212'; }

    .org-tree details:not([open]) > summary .toggle-btn { background: #28a745; }
    .org-tree details:not([open]) > summary .toggle-btn::before { content: '+'; }

    /* Team-size badge — TOP RIGHT (Actual Count including Self) */
    .team-badge {
        position: absolute; top: -10px; right: -10px;
        min-width: 22px; height: 22px; padding: 0 6px;
        border-radius: 11px; border: 2px solid #ffffff;
        background: #d9534f; color: #ffffff; font-size: 13px; font-weight: 700;
        display: flex; align-items: center; justify-content: center;
        box-shadow: 0 2px 5px rgba(0,0,0,.25); z-index: 15;
    }

    /* Planned badge — TOP LEFT (Planned Headcount) */
    .planned-badge {
        position: absolute; top: -10px; left: -10px;
        min-width: 22px; height: 22px; padding: 0 6px;
        border-radius: 11px; border: 2px solid #ffffff;
        background: #3f51b5; color: #ffffff; font-size: 13px; font-weight: 700;
        display: flex; align-items: center; justify-content: center;
        box-shadow: 0 2px 5px rgba(0,0,0,.25); z-index: 15;
    }
</style>
"

-- LEVEL 1: Root Node
VAR _rootNodes = FILTER('Table', ISBLANK('Table'[ManagerID]) || 'Table'[ManagerID] = 0)

VAR _body = 
    "<ul>" & 
    CONCATENATEX(
        _rootNodes,
        VAR _lvl1_ID = 'Table'[EmployeeID]
        VAR _lvl1_Pic = IF(ISBLANK('Table'[ImageURL]), _fallbackAvatar, 'Table'[ImageURL])
        VAR _lvl1_Dept = 'Table'[Department]
        VAR _lvl1_Name = 'Table'[EmployeeName]
        VAR _lvl1_Title = 'Table'[JobTitle]
        VAR _lvl1_Planned = IF(ISBLANK('Table'[PlannedHeadcount]), 1, 'Table'[PlannedHeadcount])

        VAR _lvl2_Nodes = FILTER('Table', 'Table'[ManagerID] = _lvl1_ID)
        VAR _lvl1_HasChildren = COUNTROWS(_lvl2_Nodes) > 0
        VAR _lvl1_TeamSize = COUNTROWS(FILTER('Table', PATHCONTAINS([OrgPath], _lvl1_ID)))
        VAR _lvl1_ChildHTML =
            IF(
                _lvl1_HasChildren,
                VAR _lvl2_AnyGrandchildren =
                    SUMX(
                        _lvl2_Nodes,
                        VAR _gcid = 'Table'[EmployeeID]
                        RETURN COUNTROWS(FILTER('Table', 'Table'[ManagerID] = _gcid))
                    ) > 0
                RETURN
                IF(
                    _lvl2_AnyGrandchildren,
                    "<ul>" &
                    CONCATENATEX(
                        _lvl2_Nodes,
                        VAR _lvl2_ID = 'Table'[EmployeeID]
                        VAR _lvl2_Pic = IF(ISBLANK('Table'[ImageURL]), _fallbackAvatar, 'Table'[ImageURL])
                        VAR _lvl2_Dept = 'Table'[Department]
                        VAR _lvl2_Name = 'Table'[EmployeeName]
                        VAR _lvl2_Title = 'Table'[JobTitle]
                        VAR _lvl2_Planned = IF(ISBLANK('Table'[PlannedHeadcount]), 1, 'Table'[PlannedHeadcount])

                        VAR _lvl3_Nodes = FILTER('Table', 'Table'[ManagerID] = _lvl2_ID)
                        VAR _lvl2_HasChildren = COUNTROWS(_lvl3_Nodes) > 0
                        VAR _lvl2_TeamSize = COUNTROWS(FILTER('Table', PATHCONTAINS([OrgPath], _lvl2_ID)))
                        VAR _lvl2_ChildHTML =
                            IF(
                                _lvl2_HasChildren,
                                VAR _lvl3_AnyGrandchildren =
                                    SUMX(
                                        _lvl3_Nodes,
                                        VAR _gcid = 'Table'[EmployeeID]
                                        RETURN COUNTROWS(FILTER('Table', 'Table'[ManagerID] = _gcid))
                                    ) > 0
                                RETURN
                                IF(
                                    _lvl3_AnyGrandchildren,
                                    "<ul>" &
                                    CONCATENATEX(
                                        _lvl3_Nodes,
                                        VAR _lvl3_ID = 'Table'[EmployeeID]
                                        VAR _lvl3_Pic = IF(ISBLANK('Table'[ImageURL]), _fallbackAvatar, 'Table'[ImageURL])
                                        VAR _lvl3_Dept = 'Table'[Department]
                                        VAR _lvl3_Name = 'Table'[EmployeeName]
                                        VAR _lvl3_Title = 'Table'[JobTitle]
                                        VAR _lvl3_Planned = IF(ISBLANK('Table'[PlannedHeadcount]), 1, 'Table'[PlannedHeadcount])

                                        VAR _lvl4_Nodes = FILTER('Table', 'Table'[ManagerID] = _lvl3_ID)
                                        VAR _lvl3_HasChildren = COUNTROWS(_lvl4_Nodes) > 0
                                        VAR _lvl3_TeamSize = COUNTROWS(FILTER('Table', PATHCONTAINS([OrgPath], _lvl3_ID)))
                                        VAR _lvl3_ChildHTML =
                                            IF(
                                                _lvl3_HasChildren,
                                                VAR _lvl4_AnyGrandchildren =
                                                    SUMX(
                                                        _lvl4_Nodes,
                                                        VAR _gcid = 'Table'[EmployeeID]
                                                        RETURN COUNTROWS(FILTER('Table', 'Table'[ManagerID] = _gcid))
                                                    ) > 0
                                                RETURN
                                                IF(
                                                    _lvl4_AnyGrandchildren,
                                                    "<ul>" &
                                                    CONCATENATEX(
                                                        _lvl4_Nodes,
                                                        VAR _lvl4_ID = 'Table'[EmployeeID]
                                                        VAR _lvl4_Pic = IF(ISBLANK('Table'[ImageURL]), _fallbackAvatar, 'Table'[ImageURL])
                                                        VAR _lvl4_Dept = 'Table'[Department]
                                                        VAR _lvl4_Name = 'Table'[EmployeeName]
                                                        VAR _lvl4_Title = 'Table'[JobTitle]
                                                        VAR _lvl4_Planned = IF(ISBLANK('Table'[PlannedHeadcount]), 1, 'Table'[PlannedHeadcount])

                                                        VAR _lvl5_Nodes = FILTER('Table', 'Table'[ManagerID] = _lvl4_ID)
                                                        VAR _lvl4_HasChildren = COUNTROWS(_lvl5_Nodes) > 0
                                                        VAR _lvl4_TeamSize = COUNTROWS(FILTER('Table', PATHCONTAINS([OrgPath], _lvl4_ID)))
                                                        VAR _lvl4_ChildHTML =
                                                            IF(
                                                                _lvl4_HasChildren,
                                                                VAR _lvl5_AnyGrandchildren =
                                                                    SUMX(
                                                                        _lvl5_Nodes,
                                                                        VAR _gcid = 'Table'[EmployeeID]
                                                                        RETURN COUNTROWS(FILTER('Table', 'Table'[ManagerID] = _gcid))
                                                                    ) > 0
                                                                RETURN
                                                                IF(
                                                                    _lvl5_AnyGrandchildren,
                                                                    "<ul>" &
                                                                    CONCATENATEX(
                                                                        _lvl5_Nodes,
                                                                        VAR _lvl5_ID = 'Table'[EmployeeID]
                                                                        VAR _lvl5_Pic = IF(ISBLANK('Table'[ImageURL]), _fallbackAvatar, 'Table'[ImageURL])
                                                                        VAR _lvl5_Dept = 'Table'[Department]
                                                                        VAR _lvl5_Name = 'Table'[EmployeeName]
                                                                        VAR _lvl5_Title = 'Table'[JobTitle]
                                                                        VAR _lvl5_Planned = IF(ISBLANK('Table'[PlannedHeadcount]), 1, 'Table'[PlannedHeadcount])

                                                                        VAR _lvl6_Nodes = FILTER('Table', 'Table'[ManagerID] = _lvl5_ID)
                                                                        VAR _lvl5_HasChildren = COUNTROWS(_lvl6_Nodes) > 0
                                                                        VAR _lvl5_TeamSize = COUNTROWS(FILTER('Table', PATHCONTAINS([OrgPath], _lvl5_ID)))
                                                                        VAR _lvl5_ChildHTML =
                                                                            IF(
                                                                                _lvl5_HasChildren,
                                                                                VAR _lvl6_AnyGrandchildren =
                                                                                    SUMX(
                                                                                        _lvl6_Nodes,
                                                                                        VAR _gcid = 'Table'[EmployeeID]
                                                                                        RETURN COUNTROWS(FILTER('Table', 'Table'[ManagerID] = _gcid))
                                                                                    ) > 0
                                                                                RETURN
                                                                                IF(
                                                                                    _lvl6_AnyGrandchildren,
                                                                                    "<ul>" &
                                                                                    CONCATENATEX(
                                                                                        _lvl6_Nodes,
                                                                                        VAR _lvl6_ID = 'Table'[EmployeeID]
                                                                                        VAR _lvl6_Pic = IF(ISBLANK('Table'[ImageURL]), _fallbackAvatar, 'Table'[ImageURL])
                                                                                        VAR _lvl6_Dept = 'Table'[Department]
                                                                                        VAR _lvl6_Name = 'Table'[EmployeeName]
                                                                                        VAR _lvl6_Title = 'Table'[JobTitle]
                                                                                        VAR _lvl6_Planned = IF(ISBLANK('Table'[PlannedHeadcount]), 1, 'Table'[PlannedHeadcount])

                                                                                        VAR _lvl7_Nodes = FILTER('Table', 'Table'[ManagerID] = _lvl6_ID)
                                                                                        VAR _lvl6_HasChildren = COUNTROWS(_lvl7_Nodes) > 0
                                                                                        VAR _lvl6_TeamSize = COUNTROWS(FILTER('Table', PATHCONTAINS([OrgPath], _lvl6_ID)))
                                                                                        VAR _lvl6_ChildHTML =
                                                                                            IF(
                                                                                                _lvl6_HasChildren,
                                                                                                "<ul class='vertical-stack'>" &
                                                                                                CONCATENATEX(
                                                                                                    _lvl7_Nodes,
                                                                                                    VAR _lvl7_ID = 'Table'[EmployeeID]
                                                                                                    VAR _lvl7_Pic = IF(ISBLANK('Table'[ImageURL]), _fallbackAvatar, 'Table'[ImageURL])
                                                                                                    VAR _lvl7_Dept = 'Table'[Department]
                                                                                                    VAR _lvl7_Name = 'Table'[EmployeeName]
                                                                                                    VAR _lvl7_Title = 'Table'[JobTitle]
                                                                                                    VAR _lvl7_Planned = IF(ISBLANK('Table'[PlannedHeadcount]), 1, 'Table'[PlannedHeadcount])
                                                                                                    RETURN
                                                                                                    "<li>" & "<div class='org-node'><span class='planned-badge' title='Planned Headcount'>" & _lvl7_Planned & "</span><img class='org-avatar' src='" & _lvl7_Pic & "' /><div class='org-info'><div class='title'>" & _lvl7_Title & "</div><div class='name'>" & _lvl7_Name & "</div></div><div class='hover-panel'><div class='panel-header'>Personnel Matrix Record</div><div class='panel-row'><span class='label'>Employee ID:</span><span class='value'>#" & _lvl7_ID & "</span></div><div class='panel-row'><span class='label'>Department:</span><span class='value'>" & _lvl7_Dept & "</span></div><div class='panel-row'><span class='label'>Total Headcount:</span><span class='value'>1</span></div></div><span class='team-badge' title='Total Headcount'>1</span></div>" & "</li>",
                                                                                                    ""
                                                                                                ) & "</ul>",
                                                                                                ""
                                                                                            )
                                                                                        VAR _lvl6_