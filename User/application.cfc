<cfcomponent>
    <cfset this.sessionmanagement = true>
    <cfset this.dataSource = "myData">
    <cfset this.name = "UserApplication">
    <cfset this.applicationTimeout = createTimeSpan(0, 12, 0, 0)>
    <cffunction  name="onRequestStart">
        <cfargument name="requestedPage" required="true">
        <cfset local.includedPages = [
            "/Shopping Cart/User/userCartPage.cfm",
            "/Shopping Cart/User/userProfilePage.cfm"
        ]>
        <cfif arrayContains(local.includedPages,arguments.requestedPage) AND NOT structKeyExists(session, "userLogin") AND NOT structKeyExists(session, "username")>
            <cflocation url="/Shopping Cart/User/userLogin.cfm" addToken="no">
        </cfif>
        <cfif structKeyExists(url, "reload")>
            <cfset onApplicationStart()>
        </cfif>
    </cffunction>
    <cffunction  name="onApplicationStart">
        <cfset application.encryptionString = generateSecretKey("AES")>
    </cffunction>
</cfcomponent>