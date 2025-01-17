<cfcomponent>
    <cfset this.sessionmanagement = true>
    <cfset this.dataSource = "myData">
    <cfset this.name = "UserApplication">
    <cfset this.applicationTimeout = createTimeSpan(0, 12, 0, 0)>
    <cffunction  name="onRequestStart">
        <cfargument name="requestedPage" required="true">
        <cfset local.excludedPages = [
                                        "/Shopping Cart/User/userLogin.cfm",
                                        "/Shopping Cart/User/userSignUp.cfm",
                                        "/Shopping Cart/User/userhomePage.cfm",
                                        "/Shopping Cart/User/Component/userComponent.cfc"
                                     ]>
        <cfif NOT arrayContains(local.excludedPages,arguments.requestedPage) AND NOT structKeyExists(session, "userLogin") AND NOT structKeyExists(session, "username")>
            <cflocation url="/Shopping Cart/User/userLogin.cfm" addToken="no">
        </cfif>
        <cfif structKeyExists(url, "reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>
    </cffunction>
</cfcomponent>