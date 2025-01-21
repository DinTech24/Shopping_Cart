<cfcomponent>
    <cfset this.sessionmanagement = true>
    <cfset this.dataSource = "myData">
    <cfset this.name = "UserApplication">
    <cfset this.applicationTimeout = createTimeSpan(0, 12, 0, 0)>
    <cffunction  name="onRequestStart">
        <cfargument name="requestedPage" required="true">
        <cfset local.includedPages = [

                                     ]>
        <cfif arrayContains(local.includedPages,arguments.requestedPage) AND NOT structKeyExists(session, "userLogin") AND NOT structKeyExists(session, "username")>
            <cflocation url="/Shopping Cart/User/userLogin.cfm" addToken="no">
        </cfif>
        <cfif structKeyExists(url, "reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>
    </cffunction>
</cfcomponent>