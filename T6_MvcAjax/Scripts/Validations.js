//添加客户端验证
//首先了解，需要验证什么？
//1. FirstName 不能为空
//2. LastName字符长度不能大于5
//3. Salary不能为空，且应该为数字类型
//4. FirstName 不能包含@字符
function IsFirstNameEmpty() {
    if (document.getElementById('TxtFName').value == "") {
        return 'First Name should not be empty';
    }
    else { return ""; }
}

function IsFirstNameInValid() {
    if (document.getElementById('TxtFName').value.indexOf("@") != -1) {
        return 'First Name should not contain @';
    }
    else { return ""; }
}

function IsLastNameInValid() {
    if (document.getElementById('TxtLName').value.length >= 5) {
        return 'Last Name should not contain more than 5 character';
    }
    else { return ""; }
}

function IsSalaryEmpty() {
    if (document.getElementById('TxtSalary').value == "") {
        return 'Salary should not be empty';
    }
    else { return ""; }
}

function IsSalaryInValid() {
    if (isNaN(document.getElementById('TxtSalary').value)) {
        return 'Enter valid salary';
    }
    else { return ""; }
}

function IsValid() {

    var FirstNameEmptyMessage = IsFirstNameEmpty();
    var FirstNameInValidMessage = IsFirstNameInValid();
    var LastNameInValidMessage = IsLastNameInValid();
    var SalaryEmptyMessage = IsSalaryEmpty();
    var SalaryInvalidMessage = IsSalaryInValid();

    var FinalErrorMessage = "Errors:";
    if (FirstNameEmptyMessage != "")
        FinalErrorMessage += "\n" + FirstNameEmptyMessage;
    if (FirstNameInValidMessage != "")
        FinalErrorMessage += "\n" + FirstNameInValidMessage;
    if (LastNameInValidMessage != "")
        FinalErrorMessage += "\n" + LastNameInValidMessage;
    if (SalaryEmptyMessage != "")
        FinalErrorMessage += "\n" + SalaryEmptyMessage;
    if (SalaryInvalidMessage != "")
        FinalErrorMessage += "\n" + SalaryInvalidMessage;

    if (FinalErrorMessage != "Errors:") {
        alert(FinalErrorMessage);
        return false;
    }
    else {
        return true;
    }
}
//为什么在点击”SaveEmployee “按钮时，需要返回关键字？
//如之前实验9讨论的，当点击提交按钮时，是给服务器发送请求，验证失败时对服务器请求没有意义。
//通过添加”return false“代码，可以取消默认的服务器请求。
//在 IsValid函数将返回false，表示验证失败来实现预期的功能。

//除了提示用户，是否可以在当前页面显示错误信息？
//是可以得，只需要为每个错误创建span 标签，默认设置为不可见，当提交按钮点击时，
//如果验证失败，使用JavaScript修改错误的可见性。

//自动获取客户端验证还有什么方法？
//是，当使用Html 帮助类，可根据服务端验证来获取自动客户端验证，在以后会详细讨论。

//服务器端验证还有没有必须使用？
//在一些JavaScript脚本代码无法使用时，服务器端可以替代使用。