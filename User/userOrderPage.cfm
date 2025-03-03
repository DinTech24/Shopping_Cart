<!DOCTYPE html>
<html lang="en">
    <head>
        <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="./CSS/userStyle.css">
        <title>User_Cart_Page</title>
        <link rel="icon" type="image/x-icon" href="../Assets/SiteImages/LogoImage.png">
 	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200..1000;1,200..1000&display=swap" rel="stylesheet">
    </head>
    <body>
        <cfoutput>
            <cfset userOrderObject = new Component.userComponent()>
            <cfif structKeyExists(form, "orderAcknowledgeButton")>
                <cflocation  url="./orderHistoryPage.cfm?pageValue=1" addToken="no">
            </cfif>
            <cfif structKeyExists(form,"orderProduct") AND structKeyExists(url,"productId")>
                <cfset variables.orderResult = userOrderObject.placeOrder(
                    orderStructure = form,
                    orderType = "buyNow"
                )>
                <cfelseif structKeyExists(form,"orderProduct")>
                    <cfset variables.orderResult = userOrderObject.placeOrder(
                        orderStructure = form
                    )>
                <cfelse>
                    <cfif session.productQuantity EQ 0 AND NOT structKeyExists(url, "productId")>
                        <cflocation  url="./userCartPage.cfm" addToken="no">
                    </cfif>
            </cfif>
            <div class="modal fade" id="staticBackdropAddress" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <form method="POST" id="userAddressForm">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropLabel">Add Address</h5>
                            </div>
                            <div class="modal-body">
                                <div>
                                    <div class="addressLabel">Enter person's First Name</div>
                                    <input name="firstName" id="firstNameId" class="inputStyleNew" type="text">
                                    <div id="firstWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">Enter person's Last Name</div>
                                    <input name="lastName" id="lastNameId" class="inputStyleNew" type="text">
                                    <div id="lastNameWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">Address Line 1</div>
                                    <input name="address1" id="address1Id" class="inputStyleNew" type="text">
                                    <div id="address1Warning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">Address Line 2</div>
                                    <input name="address2" id="address2Id" class="inputStyleNew" type="text">
                                </div>
                                <div>
                                    <div class="addressLabel">City</div>
                                    <input name="city" id="cityId" class="inputStyleNew" type="text">
                                    <div id="cityWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">State</div>
                                    <input name="state" id="stateId" class="inputStyleNew" type="text">
                                    <div id="stateWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">Pincode</div>
                                    <input name="pincode" id="pincodeId" class="inputStyleNew" type="text">
                                    <div id="pincodeWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">Phone</div>
                                    <input name="phone" id="phoneId" class="inputStyleNew" type="text">
                                    <div id="phoneWarning" class="registerWarning"></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary py-2" onclick="closeUserModal()" data-bs-dismiss="modal">Close</button>
                                <button name="addressButton" onclick="return addressModalValidation()" type="submit" class="accessButton py-2">Add</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <cfinclude  template="./userHeader.cfm">
            <cfif structKeyExists(url, "productId")>
                <cfset productResult = userOrderObject.getRandomProducts(productId = url.productId)>
            </cfif>
            <cfif structKeyExists(form, "addressButton")>
                <cfset variables.userOrderObject.saveAddress(addressStructure = form)>
            </cfif>
            <cfset variables.addressDeatils = variables.userOrderObject.getSavedAddress()>
            <cfset variables.cartDisplayResult = variables.userOrderObject.displayCart()>
            <cfset variables.quantityPrice = 0>
            <cfset variables.quantityTax = 0>
            <cfset variables.savedCard = '1111222233334444,12,26,000'>
            <form method="POST">
                <cfif structKeyExists(variables,"orderResult")>
                    <cfif variables.orderResult EQ true>
                        <div class="orderConfirmModal">
                            <div class="d-flex justify-content-center">
                                <img class="confirmationImage" src="../Assets/SiteImages/Order-Confirmation-Email.png" alt="successImg">
                            </div>
                            <div class="orderText">Order Placed Successfully</div>
                            <div class="orderTextEmail">you have recieved an email with the orderId</div>
                            <div>
                                <button name="orderAcknowledgeButton" class="orderAcknowledge">Okay</button>
                            </div>
                        </div>
                        <cfelse>
                            <div class="fs-3 fw-bold m-3 text-danger">
                                Oops! Your order is cancelled due to some unusual act
                                <a href="./userhomePage.cfm">
                                    Back to HomePage
                                </a>
                            </div>
                    </cfif>
                    <cfelse>
                        <div class="cartPath">
                            <div class="pageFullPath">
                                <a href="./userCartPage.cfm">Return to Cart Page</a>
                                <i class="fa-solid fa-chevron-right fa-xs"></i> 
                            </div>
                        </div>
                        <div class="cartPageMain" id="cartPageMainId">
                            <div class="productDescription accordion" id='accordionMain'>
                                <div>
                                    <button class=" deliveryAddressDiv accordion-item accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="##collapseOne" aria-expanded="false" aria-controls="collapseOne">
                                        Delivery Address
                                    </button>
                                    <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="##accordionMain">
                                        <input type="hidden" id="addressDetailsId" value="#queryRecordCount(variables.addressDeatils)#">
                                        <cfloop query="variables.addressDeatils">
                                            <div class='d-flex addressSubDiv py-2'>
                                                <input class="ms-2 selectedAddress" checked="checked" name="addressSelect" type="radio" value="#variables.addressDeatils.fldAddress_ID#">
                                                <div class="ps-2 d-grid">
                                                    <div>#variables.addressDeatils.fldFirstName &" "& variables.addressDeatils.fldLastName#</div>
                                                    <div>
                                                        #variables.addressDeatils.fldAddressLine1#,#variables.addressDeatils.fldAddressLine2#,
                                                        #variables.addressDeatils.fldCity#,#variables.addressDeatils.fldState# - #variables.addressDeatils.fldPincode#
                                                    </div>
                                                    <div>#variables.addressDeatils.fldPhoneNumber#</div>
                                                </div>
                                            </div>
                                        </cfloop>
                                        <div class="d-flex justify-content-center my-2">
                                            <button class="btn btn-outline-primary" onclick="clearModal()" type="button" data-bs-toggle="modal" data-bs-target="##staticBackdropAddress">Add new address +</button>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <button class=" deliveryAddressDiv accordion-item accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="##collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                        Order Summary
                                    </button>
                                    <div id="collapseTwo" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="##accordionMain">
                                        <cfif structKeyExists(url, "productId")>
                                            <div class="mainSectionBody">
                                                <div class="orderDetailsDiv pt-4">
                                                    <a href="./productPage.cfm?productId=#productResult.fldProduct_ID#">
                                                        <img class="cartImage" src="../Assets/ProductImages/#productResult.fldImageFileName#" alt="">
                                                        <input type="hidden" name="productIdHidden" value="#productResult.fldProduct_ID#">
                                                    </a>
                                                    <div class="mt-2 ms-5">
                                                        <div class="productNameSize">#productResult.fldProductName#</div>
                                                        <span class="orderDetailsSpan1">#productResult.fldBrandName#</span>
                                                        <div class="mt-3">	
                                                            <div class="orderDetailsSpan3 mt-1">
                                                                Product Price : 
                                                                <span>
                                                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                                                    <span id="buyNowPrice">
                                                                        #productResult.fldPrice#
                                                                    </span>
                                                                </span>
                                                            </div>
                                                            <div class="orderDetailsSpan3 mt-1">
                                                                Product Tax : 
                                                                <span>
                                                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                                                    <span id="buyNowTax">
                                                                        #(productResult.fldPrice*productResult.fldTax)/100#
                                                                    </span>
                                                                </span>
                                                            </div>
                                                            <div class="orderDetailsSpan mt-4">
                                                                Product Total Amount : <i class="fa-solid fa-indian-rupee-sign"></i>
                                                                #productResult.fldPrice + (productResult.fldPrice*productResult.fldTax)/100#
                                                            </div>
                                                        </div>	
                                                    </div>
                                                </div>
                                                <div class="d-flex w-50 ms-4 mt-2 justify-content-between mb-3">
                                                    <div>
                                                        <button class="prquanityIncrease" type="button" id="reduceQuantity" disabled onclick="reduceBuyQuantity()">-</button>
                                                        <span class="prquanity" id="ProductQuantitySpan">1</span>
                                                        <button  name="productIdSaved"  value="#productResult.fldProduct_ID#" class="prquanityIncrease" type="button"  id="addProductButton" onclick="addBuyQuantity()">+</button>
                                                        <input type="hidden" value=1 id="productQuanityHidden" name="productQuantity">
                                                    </div>
                                                </div>
                                            </div>
                                            <cfelse>
                                                <cfloop query="cartDisplayResult">
                                                    <div class="mainSectionBody " id="#cartDisplayResult.fldCart_ID#CartProduct">
                                                        <div class="orderDetailsDiv pt-4">
                                                            <a href="./productPage.cfm?productId=#cartDisplayResult.fldProduct_ID#">
                                                                <img class="cartImage" src="../Assets/ProductImages/#cartDisplayResult.fldImageFileName#" alt="">
                                                            </a>
                                                            <div class="mt-2 ms-5">
                                                                <div class="productNameSize">#cartDisplayResult.fldProductName#</div>
                                                                <span class="orderDetailsSpan1">#cartDisplayResult.fldBrandName#</span>
                                                                <div class="mt-3">	
                                                                    <div class="orderDetailsSpan3 mt-1">
                                                                        Product Price : 
                                                                        <span id="#cartDisplayResult.fldCart_ID#unitprice">
                                                                            <i class="fa-solid fa-indian-rupee-sign"></i>
                                                                            #cartDisplayResult.fldPrice#
                                                                        </span>

                                                                    </div>
                                                                    <div class="orderDetailsSpan3 mt-1">
                                                                        Product Tax : 
                                                                        <span id="#cartDisplayResult.fldCart_ID#unittax">
                                                                        <i class="fa-solid fa-indian-rupee-sign"></i>
                                                                            #(cartDisplayResult.fldPrice*cartDisplayResult.fldTax)/100#
                                                                        </span>
                                                                    </div>
                                                                    <div class="orderDetailsSpan3 mt-1">
                                                                        Product Quantity : 
                                                                        <span>
                                                                            #cartDisplayResult.fldQuantity#
                                                                        </span>
                                                                    </div>
                                                                    <div class="orderDetailsSpan mt-4">
                                                                        Product Total Amount : <i class="fa-solid fa-indian-rupee-sign"></i>
                                                                        #cartDisplayResult.fldPrice + (cartDisplayResult.fldPrice*cartDisplayResult.fldTax)/100#
                                                                    </div>
                                                                </div>	
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <cfset quantityPrice = quantityPrice +  (cartDisplayResult.fldPrice* cartDisplayResult.fldQuantity)>
                                                    <cfset quantityTax = quantityTax + (((cartDisplayResult.fldPrice*cartDisplayResult.fldTax)/100) * cartDisplayResult.fldQuantity)>
                                                </cfloop>
                                        </cfif>
                                    </div>
                                </div>
                                <div>
                                    <button class=" deliveryAddressDiv accordion-item accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="##collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                        Card Details
                                    </button>
                                    <div id="collapseThree" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="##accordionMain">
                                        <div class="enterCardDiv">
                                            Enter your Card Details
                                            <i class="fa-solid fa-caret-down"></i>
                                        </div>
                                        <div class="d-flex align-items-center">
                                                <div class="CardMainDiv">
                                                    <div class="CardInnerDiv">
                                                        <input class="cardNumberDiv" name="cardNumberName" id="cardNumberId" type="text" maxlength="16" placeholder="ENTER CARD NUMBER">
                                                        <div class="cardBottomDiv mx-4">
                                                            <div class="validThorughText">Valid through</div>
                                                            <div class="d-flex justify-content-between validDateDiv">
                                                                <div class="validUpto d-flex justify-content-between">
                                                                    <input class="cardValidDate" name="cardMonthName" id="cardMonthId" maxlength="2" type="text" placeholder="MM">
                                                                    <span class="cardMidSpan">|</span>
                                                                    <input class="cardValidDate" name="cardYearName" id="cardYearId" maxlength="2" type="text" placeholder="YY">
                                                                </div>
                                                                <input name="cardCvvName" class="cardCvv" id="cardCvvId" maxlength="3" type="password" placeholder="CVV">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            <div class="d-flex justify-content-center align-items-center">
                                                <button type="button" onclick="verifyCard(this)" id="verifyButtonId" class="btn btn-sm btn-outline-danger" value='#variables.savedCard#'>
                                                    Verify Card
                                                </button> 
                                                <div id="cardWarningId" class="text-center cardWarning ms-2"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="w-100 placeOrderDiv d-flex justify-content-end">
                                    <button id="placeOrderButtonId" type="submit" onclick="return placeOrderFunction()" disabled class="placeOrderButton btn" name="orderProduct">
                                        CONTINUE TO PAY
                                        <span id="paymentsAmount"></span>
                                    </button>
                                </div>
                            </div>
                            <div class="productPrice">
                                <div class="priceDetails px-4">PRICE DETAILS</div>
                                <div class="detailedAmountInnerDiv">
                                    <div class="d-flex justify-content-between px-4 pb-3 pt-2"> 
                                        <span>Total Price</span>
                                        <span>
                                            <i class="fa-solid fa-indian-rupee-sign"></i>
                                            <span id="totalprice">
                                                <cfif structKeyExists(url, "productId")>
                                                    #productResult.fldPrice#
                                                    <cfelse>
                                                        #quantityPrice#
                                                </cfif>
                                            </span>
                                        </span>
                                    </div>
                                    <div class="d-flex justify-content-between px-4 pb-3">
                                        <span>Total Tax</span>
                                        <span>
                                            <i class="fa-solid fa-indian-rupee-sign"></i>
                                            <span id="totaltax">
                                                <cfif structKeyExists(url, "productId")>
                                                    #(productResult.fldPrice*productResult.fldTax)/100#
                                                    <cfelse>
                                                        #quantityTax#
                                                </cfif>
                                            </span>
                                        </span>
                                    </div>
                                    <div class="d-flex justify-content-between px-4 pb-2"> 
                                        <span>Delivery Charges</span><span><i class="fa-solid fa-indian-rupee-sign"></i> 40</span> 
                                    </div>
                                </div>				
                                <div class="d-flex justify-content-between mx-4 pb-4 pt-4 fs-6 fw-bold borderDotted"> 
                                    <span>Total Amount</span> 
                                    <span>
                                        <i class="fa-solid fa-indian-rupee-sign"></i>
                                        <span id="totalAmount">
                                            <cfif structKeyExists(url, "productId")>
                                                #productResult.fldPrice + (productResult.fldPrice*productResult.fldTax)/100 + 40#
                                                <cfelse>
                                                    #quantityPrice + quantityTax + 40#
                                            </cfif>
                                        </span>
                                    </span>
                                </div>
                            </div>
                        </div>
                </cfif>
            </form>

        </cfoutput>
        <cfinclude  template="./footer.cfm">
        <script src="./Script/userPage.js"></script>
        <script src="../CommonScripts/validations.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
</html>