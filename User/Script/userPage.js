function registerUser(){
    var firstName = document.getElementById("firstNameId").value;
    var emailId = document.getElementById("emailIds").value;
    var password = document.getElementById("passwordId").value;
    var rePassword = document.getElementById("rePasswordId").value;
    var phone = document.getElementById("phoneId").value;
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
    var flag = true;

    if(firstName.trim() === ""){
        document.getElementById("nameWarning").innerHTML = "Firstname is required"
        flag = false;
    }else{
        document.getElementById("nameWarning").innerHTML = ""
    }

    if(phone.trim() === ""){
        document.getElementById("phoneWarning").innerHTML = "add phone number";
        flag = false;
    }else{
        if(phonePattern.test(phone) === false){
            document.getElementById("phoneWarning").innerHTML = "phone should follow the pattern";
            flag = false;
        }else{
            document.getElementById("phoneWarning").innerHTML = ""
        }
    }

    if(emailId.trim() === ""){
        document.getElementById("emailWarning").innerHTML = "email-id is required"
        flag = false;
    }else{
        if(emailPattern.test(emailId) === false){
            document.getElementById("emailWarning").innerHTML = "should follow email Pattern"
            flag = false;
        }else{
            document.getElementById("emailWarning").innerHTML = ""
        }
    }


    if(password.trim() === ""){
        document.getElementById("passWarning").innerHTML = "password is required"
        flag = false;
    }else{
        if(password.includes(" ")){
            document.getElementById("passWarning").innerHTML = "password shouldn't contain spaces"
            flag = false;
        }else if(password.length < 6){
            document.getElementById("passWarning").innerHTML = "password should atleast have 6 characters"
            flag = false;
        }else if(password !== rePassword){
            document.getElementById("passWarning").innerHTML = ""
            document.getElementById("repassWarning").innerHTML = "passwords doesn't match"
            flag = false;
        }else{
            document.getElementById("repassWarning").innerHTML = ""
            document.getElementById("passWarning").innerHTML = ""
        }
    }
    
    if(flag == false){
        event.preventDefault();
    }
    return flag;
}

function logoutFunction(){
    if(confirm("Confirm to logout")){
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=logoutUser",
            success:function(){
                    window.location.href = "./userhomePage.cfm"
                }
        })
    }
}

function closeUserModal(){
    document.getElementById("userLoginForm").reset();
}

function loginModal(){
    document.getElementById("passWarning").innerHTML = ""
    document.getElementById("emailWarning").innerHTML = ""
    var emailId = document.getElementById("emailIds").value;
    var password = document.getElementById("passwordId").value;
    var flag = true;
    if(emailId.trim() === ""){
        document.getElementById("emailWarning").innerHTML = "EmailId is required"
        flag = false;
    }else{
        document.getElementById("emailWarning").innerHTML = ""
    }
    if(password.trim() === ""){
        document.getElementById("passWarning").innerHTML = "Password is required"
        flag = false;
    }else{
        document.getElementById("passWarning").innerHTML = ""
    }
    if(flag)
        var jsCall = true;
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=loginUser",
            data:{enteredId:emailId,enteredPassword:password,jsCall:jsCall},
            success:function(result){
                if(result){
                    result = JSON.parse(result);
                    event.preventDefault();
                    if(result["Message"] == "true"){
                        location.reload();
                    }else{
                        document.getElementById("passWarning").innerHTML = result["Message"]
                    }
                    
                }
            }
        })
    
}

function modalClear(){
    document.getElementById("userLoginForm").reset();
    document.getElementById("passWarning").innerHTML = ""
    document.getElementById("emailWarning").innerHTML = ""
}

function enableInputs(){
    document.getElementById("minVal").disabled = false;
    document.getElementById("maxVal").disabled = false;
}

function disableInputs(){
    document.getElementById("minVal").disabled = true;
    document.getElementById("maxVal").disabled = true;
}

function getFilterResult(subCategoryId){
    var flag = false;
    minVal = document.getElementById("minVal").value;
    maxVal = document.getElementById("maxVal").value;
    for(i=1;i<=4;i++){
        if(document.getElementById("filterRadio"+i).checked){
            flag = true
            var filterRangeVal = document.getElementById("filterRadio"+i).value;
            break;
        }else{
            if((i==4)&&(flag == false)){
                if((minVal=="")&&(maxVal=="")){
                    alert("Select a Range to continue")
                }else{
                    var filterRangeVal=`["${minVal}","${maxVal}"]`
                    flag=true
                }
            }
        }
    }
    if(flag==true){
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=selectPriceRange",
            data:{filterRange:filterRangeVal,subCategoryId:subCategoryId},
            success:function(result){
                var result = JSON.parse(result)
                document.getElementById("randomProductsMainDivId").innerHTML = ""
                if(result.length == 0){
                    var emptyStatement = "No products to display in the price range"
                    $("#randomProductsMainDivId").append(emptyStatement);
                    document.getElementById("viewMore").style.display = "none"
                }else{
                    for(j=0;j<result.length;j++){
                        var eachProducts = 
                        `<div class="card randomProductCard" style="width: 13rem;">
                            <a href="./productPage.cfm?productId=${result[j].fldProduct_ID}">
                                <img src="../Assets/ProductImages/${result[j].fldImageFileName}" class="card-img-top randProductImage" alt="Product Image">
                            </a>
                            <div class="card-body randProductbody">
                                <div class="card-text randProductName">${result[j].fldProductName}</div>
                                <div>${result[j].fldBrandName}</div>
                                <div class="card-text randProductPrice">
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                    ${result[j].fldPrice + result[j].fldTax}
                                </div>
                            </div>
                        </div>`
                        $("#randomProductsMainDivId").append(eachProducts);
                        document.getElementById("viewMore").style.display = "initial"
                    }
                }
            }
        })
    }
}

function addProductQuantity(cartId){
    var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
    document.getElementById(cartId.value+"quantity").innerHTML = Number(prQuantity) + 1
    var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
    var price = document.getElementById(cartId.value+"unitprice").innerHTML;
    var tax = document.getElementById(cartId.value+"unittax").innerHTML;
    var totalprice = document.getElementById("totalprice").innerHTML;
    var totaltax = document.getElementById("totaltax").innerHTML;
    var totalamount = document.getElementById("totalamount").innerHTML;
    document.getElementById("totalprice").innerHTML = Number(totalprice) + Number(price);
    document.getElementById("totaltax").innerHTML = Number(totaltax) +Number(tax);
    document.getElementById("totalamount").innerHTML = Number(totalamount) + Number(tax) + Number(price);
    $.ajax({
        type:"POST",
        url:"Component/userComponent.cfc?method=updateCartQuantity",
        data:{cartId:cartId.value,prQuantity:prQuantity}
    })
}

function reduceProductQuantity(cartId){
    var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
    document.getElementById(cartId.value+"quantity").innerHTML = Number(prQuantity) - 1
    var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
    var price = document.getElementById(cartId.value+"unitprice").innerHTML;
    var tax = document.getElementById(cartId.value+"unittax").innerHTML;
    var totalprice = document.getElementById("totalprice").innerHTML;
    var totaltax = document.getElementById("totaltax").innerHTML;
    var totalamount = document.getElementById("totalamount").innerHTML;
    document.getElementById("totalprice").innerHTML = Number(totalprice) - Number(price);
    document.getElementById("totaltax").innerHTML = Number(totaltax) - Number(tax);
    document.getElementById("totalamount").innerHTML = (Number(totalamount) - Number(tax)) - Number(price);
    if(prQuantity == 0){
        document.getElementById(cartId.value+"CartProduct").remove()
        var producttotalQuantity = document.getElementById("productQuantityId").innerHTML;
        document.getElementById("productQuantityId").innerHTML = Number(producttotalQuantity)-1;
        var producttotalQuantity = document.getElementById("productQuantityId").innerHTML;
        if(producttotalQuantity == 0){
            document.getElementById("cartPageMainId").innerHTML = 
                `<div class="d-flex justify-content-center">
                    <img src="../Assets/SiteImages/Empty_Shopping.jpg">
                </div>`
        }
    }
    $.ajax({
        type:"POST",
        url:"Component/userComponent.cfc?method=updateCartQuantity",
        data:{cartId:cartId.value,prQuantity:Number(prQuantity)}
    })
}

function removeCart(cartId){
    if(confirm("Are you sure to remove product from cart?")){
        var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
        var price = document.getElementById(cartId.value+"unitprice").innerHTML;
        var tax = document.getElementById(cartId.value+"unittax").innerHTML;
        var totalprice = document.getElementById("totalprice").innerHTML;
        var totaltax = document.getElementById("totaltax").innerHTML;
        var totalamount = document.getElementById("totalamount").innerHTML;
        var qtyPrice = Number(prQuantity)*Number(price)
        var qtyTax = Number(prQuantity)*Number(tax)
        var totalQtyAmount = qtyPrice + qtyTax;
        document.getElementById("totalamount").innerHTML = Number(totalamount) - totalQtyAmount;
        document.getElementById("totalprice").innerHTML = Number(totalprice) - Number(qtyPrice)
        document.getElementById("totaltax").innerHTML = Number(totaltax) - Number(qtyTax)
        document.getElementById(cartId.value+"CartProduct").remove()
        var producttotalQuantity = document.getElementById("productQuantityId").innerHTML;
        document.getElementById("productQuantityId").innerHTML = Number(producttotalQuantity)-1;
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=deleteCart",
            data:{cartId:cartId.value}
        })
        var producttotalQuantity = document.getElementById("productQuantityId").innerHTML;
        if(producttotalQuantity == 0){
            document.getElementById("cartPageMainId").innerHTML = 
            `<div class="d-flex justify-content-center">
                <img src="../Assets/SiteImages/Empty_Shopping.jpg">
            </div>`
        }
    }
}

function removeHeightClass(){
    document.getElementById("randomProductsMainDivId").classList.remove("initialDivHeight");
    document.getElementById("viewMore").style.display = "none"
}

function searchValidate(){
    var searchKey = document.getElementById("searchInput").value;
    if(searchKey.trim().length == 0){
        alert("Enter keyword to search")
        return false
    }else{
        document.getElementById("searchInput").value = searchKey.trim();
        return true
    }
}

function addressModalValidation(){
    var firstName = document.getElementById("firstNameId").value;
    var address1 = document.getElementById("address1Id").value;
    var city = document.getElementById("cityId").value;
    var state = document.getElementById("stateId").value;
    var pincode = document.getElementById("pincodeId").value;
    var phone = document.getElementById("phoneId").value;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
    var flag = true;
    if(firstName.trim().length == 0){
        document.getElementById("firstWarning").innerHTML = "firstName is empty"
        document.getElementById("firstNameId").focus();
        document.getElementById("firstNameId").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("firstWarning").innerHTML = ""
        document.getElementById("firstNameId").style.border = "1px solid black";
    }

    if(address1 === ""){
        document.getElementById("address1Warning").innerHTML = "address line 1 is empty"
        document.getElementById("address1Id").focus();
        document.getElementById("address1Id").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("address1Warning").innerHTML = ""
        document.getElementById("address1Id").style.border = "1px solid black";
    }

    if(city === ""){
        document.getElementById("cityWarning").innerHTML = "city is empty"
        document.getElementById("cityId").focus();
        document.getElementById("cityId").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("cityWarning").innerHTML = ""
        document.getElementById("cityId").style.border = "1px solid black";
    }

    if(state === ""){
        document.getElementById("stateWarning").innerHTML = "state is empty"
        document.getElementById("stateId").focus();
        document.getElementById("stateId").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("stateWarning").innerHTML = ""
        document.getElementById("stateId").style.border = "1px solid black";
    }
    
    if(pincode.trim() === ""){
        document.getElementById("pincodeWarning").innerHTML = "pincode is empty";
        document.getElementById("pincodeId").focus();
        document.getElementById("pincodeId").style.border = "2px solid red";
        flag = false;
    }else{
        if(pincode.length !== 6){
            document.getElementById("pincodeWarning").innerHTML = "enter 6 digit pincode";
            flag = false;
        }else if(/^[0-9]{6}$/.test(pincode) === false){
            document.getElementById("pincodeWarning").innerHTML = "pincode should only contain digits";
            flag = false;
        }else{
            document.getElementById("pincodeWarning").innerHTML = "";
            document.getElementById("pincodeId").style.border = "1px solid black";
        }
    }

    if(phone === ""){
        document.getElementById("phoneWarning").innerHTML = "Phone Number is empty"
        document.getElementById("phoneId").focus();
        document.getElementById("phoneId").style.border = "2px solid red";
        flag = false;
    }else{
        if(!phonePattern.test(phone)){
            document.getElementById("phoneWarning").innerHTML = "Phone Number should follow pattern"
            flag = false;
        }else{
            document.getElementById("phoneWarning").innerHTML = ""
            document.getElementById("phoneId").style.border = "1px solid black";
        }
    }
    if(flag === false){
        event.preventDefault()
    }
    return flag;
}

function clearModal(){
    const nodeList = document.querySelectorAll(".registerWarning");
    const nodeListNew = document.querySelectorAll(".inputStyleNew");
    document.getElementById("userAddressForm").reset();
    for (let i = 0; i < nodeList.length; i++) {
        nodeList[i].innerHTML = "";
    }
    for (let j = 0; j < nodeList.length; j++) {
        nodeListNew[j].style.border = "1px solid black";
    }
}

function removeAddress(addressId){
    if(confirm("Confirm to remove address")){
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=deleteAddress",
            data:{addressId:addressId.value},
            success:function(){
                    document.getElementById(addressId.value+"address").remove();
                }
        })
    }
}

window.addEventListener('pageshow', (event) => {
    if (event.persisted) {
      window.location.reload();
    }
});

if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}


