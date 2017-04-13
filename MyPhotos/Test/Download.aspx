<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Download.aspx.cs" Inherits="Test.T3.Download" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>DownLoading...</h2>
        <p>
            <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
        </p>
        <p>
            <asp:Button ID="Button2" runat="server" Text="Button" OnClick="Button2_Click" />
        </p>
        <p>
            <asp:Button ID="Button3" runat="server" Text="Button" OnClick="Button3_Click" />
        </p>
        <p>
            <asp:Button ID="Button4" runat="server" Text="Button" OnClick="Button4_Click" />
        </p>
    </form>
</body>
</html>
