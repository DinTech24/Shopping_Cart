<cfcomponent>
    <cfset this.sessionmanagement = true>
    <cfset this.dataSource = "myData">
    <cfset this.name = "ShoppingCartApplication">
    <cfset this.applicationTimeout = createTimeSpan(0, 12, 0, 0)>
    <cfset this.sessionTimeout = createTimeSpan(0, 0, 45, 0)>
    

    <cffunction  name="onRequestStart">
        <cfargument name="requestedPage" required="true">
        <cfset local.userIncludedPages = [
            "/User/userCartPage.cfm",
            "/User/userProfilePage.cfm",
            "/User/userOrderPage.cfm",
            "/User/orderHistoryPage.cfm"
        ]>
        <cfset local.adminIncludedPages = [
            "/Admin/adminHomePage.cfm",
            "/Admin/adminHomeProduct.cfm",
            "/Admin/adminHomeSubcategory.cfm"
        ]>
        <cfif arrayContains(local.userIncludedPages,arguments.requestedPage)>
            <cfif NOT structKeyExists(session, "userLogin") AND NOT structKeyExists(session, "username")>
                <cflocation url="/User/userhomePage.cfm" addToken="no">
            </cfif>
        <cfelseif arrayContains(local.adminIncludedPages,arguments.requestedPage)>
            <cfif NOT structKeyExists(session, "adminLogin") AND NOT structKeyExists(session, "username")>
                <cflocation url="/Admin/adminLoginpage.cfm" addToken="no">
            </cfif>
        </cfif>
    </cffunction>

    <cffunction  name="onError" returnType="void">
        <cfargument name="exception">
        <cfset local.a = arguments.exception.message>
        <cfmail from="dinilvallikunnil@gmail.com" subject="eCart Error" to="abhijithtechversant@gmail.com">
            #arguments.exception.message#
            #arguments.exception.detail#
            <cfif structKeyExists(arguments.exception.TagContext[1],"Raw_trace")>
                #arguments.exception.TagContext[1].Raw_trace#
            <cfelseif structKeyExists(arguments.exception.TagContext[2],"Raw_trace")>
                #arguments.exception.TagContext[2].Raw_trace#
            </cfif>
        </cfmail>
        <cfif structKeyExists(session,"adminLogin")>
            <cflocation url="../errorPage.cfm?admin" addToken="no">
        <cfelse>
            <cflocation url="../errorPage.cfm" addToken="no">
        </cfif>
    </cffunction>

</cfcomponent>