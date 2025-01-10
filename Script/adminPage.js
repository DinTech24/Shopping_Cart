function adminLogin(){
    var adminuser = document.getElementById("adminUsername").value;
    var adminpassword = document.getElementById("adminPassword").value;
    var flag = true;
    if(adminuser.trim().length == 0){
        document.getElementById("userWarning").innerHTML = "enter username to login"
        flag = false;
    }else{
        document.getElementById("userWarning").innerHTML = ""
    }
    if(adminpassword.trim().length == 0){
        document.getElementById("passwordWarning").innerHTML = "enter password to login"
        flag = false;
    }else{
        document.getElementById("passwordWarning").innerHTML = ""
    }
    if(!flag){
        event.preventDefault();
    }
}

function categoryValidation(){
    var newcategory = document.getElementById("categoryId").value;
    var modalType = document.getElementById("categorySubmitButton").name;
    if(newcategory.trim().length == 0){
        document.getElementById("addcategoryWarning").innerHTML = "enter category name"
        return false;
    }else if(modalType === "categoryCreateSubmit"){
        $.ajax({
            type:"POST",
            data:{newCategory:newcategory},
            url:"Component/adminComponent.cfc?method=insertCategories",
            success:function(result){
                if(result){
                    alert("Same Category Exists")
                }else{
                    location.reload()
                }
            }
        })
    }else{
        var categoryId = document.getElementById("categorySubmitButton").value
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=editCategory",
            data:{categoryId:categoryId,newcategory:newcategory},
            success:function(result){
                if(result){
                    alert("Same Category Exists")
                }else{
                    location.reload()
                }
            }
        })
    }
}

function subCategoryValidation(){
    var newsubCategory = document.getElementById("subCategoryId").value;
    if(newsubCategory.trim().length == 0){
        document.getElementById("addcategoryWarning").innerHTML = "enter Sub-Category name"
        return false;
    }else{
        var categoryId = document.getElementById("categorySubmitButton").value
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=addSubCategory",
            data:{categoryId:categoryId,newsubCategory:newsubCategory},
            success:function(result){
                if(result){
                    alert("Same Sub-category Exists")
                }else{
                    location.reload()
                }
            }
        })
    }
}

function closeAdminModal(){
    document.getElementById("adminCategoryForm").reset();
    document.getElementById("addcategoryWarning").innerHTML = ""
}

function deleteCategory(categoryId){
    if(confirm("Confirm to delete")){
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=deleteCategory",
            data:{categoryId:categoryId.value},
            success:function(){
                    location.reload()
                }
        })
    }
}


function logout(){
    if(confirm("Confirm to logout")){
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=adminLogout",
            success:function(){
                    location.reload()
            }
        })
    }
}

function createCategory(){
    document.getElementById("staticBackdropLabel").innerHTML = "Add new Category";
    document.getElementById("categorySubmitButton").name = "categoryCreateSubmit"
}

function editCategory(categoryId){
    document.getElementById("staticBackdropLabel").innerHTML = "Edit Category";
    document.getElementById("categorySubmitButton").name = "categoryEditSubmit"
    document.getElementById("categorySubmitButton").value = categoryId.value;
    document.getElementById("categoryId").value = document.getElementById("categoryEdit"+categoryId.value).innerHTML
}

function editSubcategoryModal(subCategoryId,categoryId){
    var subCategoryName = document.getElementById(subCategoryId.value).innerHTML;
    document.getElementById("editSubCategoryId").value = subCategoryName;
    document.getElementById(categoryId+"Category").selected = true;
    document.getElementById("subcategorySubmitButton").value = subCategoryId.value;

}


function deleteSubCategory(subcategoryId){
    if(confirm("Confirm to delete")){
        document.getElementById("eachSub"+subcategoryId.value).remove();
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=deleteSubcategory",
            data:{subcategoryId:subcategoryId.value},
            success:function(){
                    location.reload()
            }
        })
    }
}

if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}
