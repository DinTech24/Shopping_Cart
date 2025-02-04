<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Home Page</title>
        <link rel="stylesheet" href="./CSS/userStyle.css">
        <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <cfinclude  template="./userHeader.cfm">
        <cfoutput>
            <cfset variables.orderHistoryObject = new Component.userComponent()>
            <cfset  variables.orderHistoryResult =  variables.orderHistoryObject.displayOrderHistory()>
            <div>
                <form method="POST">
                    <div class="orderHistoryHead d-flex justify-content-between">
                        <div>
                            Order History
                        </div>
                        <input type="text" id="searchOrderId" onInput="searchOrder()" class="form-control w-25" placeholder="Search using orderId">
                    </div>
                    <div id="orderHistorymainDivId">
                        <cfloop query="variables.orderHistoryResult" group="fldOrder_ID">
                            <cfset variables.orderId = variables.orderHistoryResult.fldOrder_ID>
                            <div class="mainSectionBody" id="#variables.orderId#">
                                <div class="d-flex orderIdMain justify-content-between">
                                    <div class="orderIdDiv">
                                        ORDER ID :  #variables.orderHistoryResult.fldOrderId#
                                    </div>
                                    <button onclick="return downloadConfirmation()" name="#variables.orderHistoryResult.fldOrderId#" type="submit" class="printButton">Download Invoice <i class="fa-regular fa-file-pdf"></i></button>
                                </div>
                                <cfloop query="variables.orderHistoryResult">
                                    <cfif variables.orderHistoryResult.fldOrderId EQ variables.orderId>
                                        <div class="orderInnerDiv ps-3 pt-4">
                                            <img class="orderHistory" src="../Assets/ProductImages/#variables.orderHistoryResult.fldImageFileName#" alt="">
                                            <div class="mt-2 ms-5">
                                                <div class="productNameSize fw-bold">#variables.orderHistoryResult.fldProductName#</div>
                                                <span class="orderDetailsSpan1 fw-bold">#variables.orderHistoryResult.fldBrandName#</span>
                                                <div class="mt-3">	
                                                    <div class="orderDetailsSpa3 mt-2">
                                                        Product Total Amount : <i class="fa-solid fa-indian-rupee-sign"></i>
                                                        #variables.orderHistoryResult.fldUnitPrice + variables.orderHistoryResult.fldUnitTax#
                                                    </div>
                                                    <div class="orderDetailsSpa3 mt-2">
                                                        Product Quantity : #variables.orderHistoryResult.fldQuantity#
                                                    </div>
                                                </div>	
                                            </div>
                                        </div>
                                    </cfif>
                                </cfloop>
                                <div class="shippingAddressDiv">
                                    <div class="d-flex justify-content-between shippingAddressInner">
                                        <div>
                                            <div class="ms-2">Shipping Address:</div>
                                            <div class="ms-2">#variables.orderHistoryResult.fldFirstName &" "& variables.orderHistoryResult.fldLastName#</div>
                                            <div class="ms-2">#variables.orderHistoryResult.fldAddressLine1 &","&variables.orderHistoryResult.fldAddressLine2#</div>
                                            <div class="ms-2">#variables.orderHistoryResult.fldCity#,#variables.orderHistoryResult.fldState &"-"& variables.orderHistoryResult.fldPincode#</div> 
                                            <div class="ms-2">#variables.orderHistoryResult.fldPhoneNumber#</div> 
                                        </div>
                                        <div>
                                            <div>Payment Details:</div>
                                            <div>Payment Mode : Card</div>
                                            <div>Card Number : XXXX-XXXX-XXXX-#variables.orderHistoryResult.fldCardPart#</div>
                                        </div>
                                    </div>
                                    <div class="productOrderFooter">
                                        <div>Total Amount :  <i class="fa-solid fa-indian-rupee-sign"></i> #variables.orderHistoryResult.fldTotalPrice + variables.orderHistoryResult.fldTotalTax#</div>
                                        <div>Order Date : #dateFormat(variables.orderHistoryResult.fldorderDate,"dd mmmm yyyy")#</div>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                    </div>
                </div>
            </form>
           <cfloop query="variables.orderHistoryResult" group="fldOrder_ID">
                <cfset variables.currentId = variables.orderHistoryResult.fldOrder_ID>
                <cfif structKeyExists(form,"#variables.orderHistoryResult.fldOrder_ID#")>
                    <cfdocument format="pdf" fileName="../Assets/OrderInvoices/#session.username# #dateTimeFormat(now(),'dd-mm-yyy-HH.nn.ss')#.pdf" overwrite="true" orientation = "landscape">
                        <div>
                            <div>
                                <div>Shipping Address:</div>
                                <div>#variables.orderHistoryResult.fldFirstName &" "& variables.orderHistoryResult.fldLastName#</div>
                                <div>#variables.orderHistoryResult.fldAddressLine1 &","&variables.orderHistoryResult.fldAddressLine2#</div>
                                <div>#variables.orderHistoryResult.fldCity#,#variables.orderHistoryResult.fldState &"-"& variables.orderHistoryResult.fldPincode#</div> 
                                <div class="ms-2">#variables.orderHistoryResult.fldPhoneNumber#</div> 
                            </div>
                            <br/><br/>
                            <div>ORDER ID : #variables.currentId#</div>
                        </div>
                        <table border = "1"> 
                            <tr>
                                <th>Product Name</th>
                                <th>Brand </th>
                                <th>Product Price</th>
                                <th>Product Tax</th>
                                <th>Product Quantity</th>
                            </tr>
                            <cfloop query="#variables.orderHistoryResult#">
                                <cfif variables.orderHistoryResult.fldOrder_ID EQ variables.currentId>
                                    <tr>
                                        <td>#variables.orderHistoryResult.fldProductName#</td>
                                        <td>#variables.orderHistoryResult.fldBrandName#</td>
                                        <td>#variables.orderHistoryResult.fldUnitPrice#</td>
                                        <td>#variables.orderHistoryResult.fldUnitTax#</td>
                                        <td>#variables.orderHistoryResult.fldQuantity#</td>
                                    </tr> 
                                </cfif>
                            </cfloop> 
                        </table>
                        <br/>
                        <div>
                            Total Amount : #variables.orderHistoryResult.fldTotalPrice + variables.orderHistoryResult.fldTotalTax#
                        </div>
                        <center>
                            <div>
                                Order Date : #dateFormat(variables.orderHistoryResult.fldorderDate,"dd mmmm yyyy")#
                            </div>
                        </center>
                    </cfdocument>
                </cfif> 
           </cfloop>
            <cfinclude  template="./footer.cfm">
        </cfoutput>
        <script src="./Script/userPage.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
</html>