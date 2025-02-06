<cfcomponent>
    <cfset this.sessionmanagement = true>
    <cfset this.dataSource = "myData">
    <cfset this.name = "MyApplication">
    <cfset this.applicationTimeout = createTimeSpan(0, 12, 0, 0)>

    <cffunction  name="onRequestStart">
        <cfargument name="requestedPage" required="true">
        <cfset local.excludedPages = [
                                        "/Admin/adminLoginpage.cfm"
                                     ]>
        <cfif NOT arrayContains(local.excludedPages,arguments.requestedPage) AND NOT structKeyExists(session, "adminLogin") AND NOT structKeyExists(session, "username")>
            <cflocation url="/Admin/adminLoginpage.cfm">
        </cfif>
    </cffunction>

    <cffunction  name="onError" returnType="void">
        <cfargument name="exception" type="string">
        <cfargument name="eventName" type="string">
        <cflocation  url="./errorPage.cfm?error=#arguments.exception#">
    </cffunction>

    <cffunction  name="onApplicationStart">
        <cfset application.encryptionString = generateSecretKey("AES")>
    </cffunction>

</cfcomponent>