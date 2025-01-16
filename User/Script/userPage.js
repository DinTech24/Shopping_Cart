function registerUser(){
    var firstName = document.getElementById("firstNameId").value;
    var lastName = document.getElementById("lastNameId").value;
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

