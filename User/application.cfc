<cfcomponent>
    <cfset this.sessionmanagement = true>
    <cfset this.dataSource = "myData">
    <cfset this.name = "UserApplication">
    <cfset this.applicationTimeout = createTimeSpan(0, 12, 0, 0)>
<!---     <cffunction  name="onRequestStart">
        <cfargument name="requestedPage" required="true">
        <cfset local.excludedPages = [
                                        "/Shopping Cart/adminLoginpage.cfm"
                                     ]>
        <cfif NOT arrayContains(local.excludedPages,arguments.requestedPage) AND NOT structKeyExists(session, "userLogin") AND NOT structKeyExists(session, "username")>
            <cflocation url="/Shopping Cart/adminLoginpage.cfm">
        </cfif>
    </cffunction> --->
</cfcomponent>