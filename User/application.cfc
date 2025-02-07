<cfcomponent>
    <cfset this.sessionmanagement = true>
    <cfset this.dataSource = "myData">
    <cfset this.name = "UserApplication">
    <cfset this.applicationTimeout = createTimeSpan(0, 12, 0, 0)>

    <cffunction  name="onRequestStart">
        <cfargument name="requestedPage" required="true">
        <cfset local.includedPages = [
            "/User/userCartPage.cfm",
            "/User/userProfilePage.cfm",
            "/User/userOrderPage.cfm",
            "/User/orderHistoryPage.cfm"
        ]>
        <cfif arrayContains(local.includedPages,arguments.requestedPage) 
        AND NOT structKeyExists(session, "userLogin") 
        AND NOT structKeyExists(session, "username")>
            <cflocation url="/User/userhomePage.cfm" addToken="no">
        </cfif>
        <cfif structKeyExists(url, "reload")>
            <cfset onApplicationStart()>
        </cfif>
    </cffunction>

    <cffunction  name="onApplicationStart">
        <cfset application.encryptionString = generateSecretKey("AES")>
    </cffunction>

    <cffunction  name="onError" returnType="void">
        <cfargument name="exception" type="string">
        <cfargument name="eventName" type="string">
        <cflocation  url="./errorPage.cfm?error=#arguments.exception#">
    </cffunction>

</cfcomponent>