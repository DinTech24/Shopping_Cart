<!DOCTYPE html>
<html lang="en">
    <head>
        <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="./CSS/userStyle.css">
        <title>User_Cart_Page</title>
 	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <cfoutput>
            <cfset userCartObject = new Component.userComponent()>
            <cfif structKeyExists(url,"productId")>
                <cfset cartResult = userCartObject.addToCart(productId = url.productId)>
                <cflocation  url="./userCartPage.cfm">
            </cfif>
            <cfset cartProductDisplayResult = userCartObject.displayCart()>
            <cfset cartDisplayResult = userCartObject.getRandomProducts(sort = "negative")>
            <cfset totalPrice = 0>
            <cfset totalTax = 0>
            <cfset quantityPrice = 0>
            <cfset quantityTax = 0>
            <cfset productQuantity = 0>
            <cfinclude  template="./userHeader.cfm">
            <div class="cartPageMain" id="cartPageMain">
                <div class="productDescription">
                    <cfloop query="cartDisplayResult">
                        <cfloop query="cartProductDisplayResult">
                            <cfif cartProductDisplayResult.fldProductId EQ cartDisplayResult.fldProduct_ID>
                                <cfset productQuantity = productQuantity + 1>
                                <div class="mainSectionBody " id="#cartProductDisplayResult.fldCart_ID#CartProduct">
                                    <div class="orderDetailsDiv pt-4">
                                        <a href="" >
                                            <img class="cartImage" src="../Assets/ProductImages/#cartDisplayResult.fldImageFileName#" alt="">
                                        </a>
                                        <div class="mt-2 ms-5">
                                            <div class="productNameSize">#cartDisplayResult.fldProductName#</div>
                                            <span class="orderDetailsSpan1">#cartDisplayResult.fldBrandName#</span>
                                            <div class="mt-3">	
                                                <div class="orderDetailsSpan3 mt-1">
                                                    Product Price : 
                                                    <span id="#cartProductDisplayResult.fldCart_ID#unitprice">
                                                        #cartDisplayResult.fldPrice#
                                                    </span>
                                                </div>
                                                <div class="orderDetailsSpan3 mt-1">
                                                    Product Tax : 
                                                    <span id="#cartProductDisplayResult.fldCart_ID#unittax">
                                                        #cartDisplayResult.fldTax#
                                                    </span>
                                                </div>
                                                <div class="orderDetailsSpan mt-4">
                                                    Product Total Amount : #cartDisplayResult.fldPrice + cartDisplayResult.fldTax#
                                                </div>
                                            </div>	
                                        </div>
                                    </div>
                                    <div class="d-flex w-50 ms-5 mt-2 justify-content-between mb-3">
                                        <div>
                                            <button class="prquanityIncrease" value="#cartProductDisplayResult.fldCart_ID#" onclick="reduceProductQuantity(this,#productQuantity#)">-</button>
                                            <span class="prquanity" id="#cartProductDisplayResult.fldCart_ID#quantity">#cartProductDisplayResult.fldQuantity#</span>
                                            <button class="prquanityIncrease" value="#cartProductDisplayResult.fldCart_ID#" id="addProductButton" onclick="addProductQuantity(this,#productQuantity#)">+</button>
                                        </div>
                                        <button value="#cartProductDisplayResult.fldCart_ID#" onclick="removeCart(this)" class="fontWeight">REMOVE</button>
                                    </div>
                                </div>
                                <cfset quantityPrice = quantityPrice +  (cartDisplayResult.fldPrice* cartProductDisplayResult.fldQuantity)>
                                <cfset quantityTax = quantityTax + (cartDisplayResult.fldTax * cartProductDisplayResult.fldQuantity)>
                            </cfif>
                        </cfloop>
                    </cfloop>
                    <cfif productQuantity NEQ 0>
                        <div class="w-100 placeOrderDiv">
                                <div class="placeOrderButton">PLACE ORDER</div>
                        </div>
                        <cfelse>
                            <div class="d-flex justify-content-center">
                                <img src="../Assets/SiteImages/Empty_Shopping.jpg">
                            </div>
                    </cfif>
                </div>
                <cfif productQuantity NEQ 0>
                    <div class="productPrice">
                        <div class="priceDetails px-4">PRICE DETAILS</div>
                        <div class="detailedAmountInnerDiv">
                            <div class="d-flex justify-content-between px-4 pb-3 pt-2"> 
                                <span>Total Price</span>
                                <span id="totalprice">
                                    #quantityPrice#
                                </span>
                            </div>
                            <div class="d-flex justify-content-between px-4 pb-3">
                                <span>Total Tax</span>
                                <span id="totaltax">
                                    #quantityTax#</span>
                                </div>
                            <div class="d-flex justify-content-between px-4 pb-2"> <span>Delivery Charges</span> <span>40</span> </div>
                        </div>				
                        <div class="d-flex justify-content-between mx-4 pb-4 pt-4 fs-6 fw-bold borderDotted"> 
                            <span>Total Amount</span> 
                            <span id="totalamount">#quantityPrice + quantityTax + 40#</span>
                        </div>
                    </div>
                </cfif>
            </div>	
        </cfoutput>
        <cfinclude  template="./footer.cfm">
        <script src="./Script/userPage.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
</html>