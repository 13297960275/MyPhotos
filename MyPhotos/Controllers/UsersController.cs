﻿using JPager.Net;
using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using MyPhotos.Common;
using MyPhotos.DAL;
using MyPhotos.Models;
using MyPhotos.ViewModels;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace MyPhotos.Controllers
{
    [Authorize]
    //[AllowAnonymous]
    public class UsersController : Controller
    {
        private BaseDBContext db = new BaseDBContext();
        private Authentication authentication = new Authentication();
        private UserDALBaseRepository udbr = new UserDALBaseRepository();

        #region 用户操作

        /// <summary>
        /// 分页显示用户列表
        /// </summary>
        /// <param name="param">继承了PagerInBase的User</param>
        /// <returns></returns>
        public ActionResult Index(UserParams param)
        {
            //每页显示的条数默认10
            //param.PageSize = 6;
            ViewBag.SearchUserName = param.PageSize;

            //保存搜索条件
            ViewBag.SearchUserName = param.UserName;
            //ViewBag.SearchRegisterTime = param.RegistrationTime;
            //ViewBag.SearchRoleName = param.Roles.RoleName;

            //获取数据集合
            //var list = PageContent();
            var list = db.Users.Include(u => u.Roles).ToList();
            //var list = new List<User>();

            //根据条件检索
            var query = param.UserName != null ? list.Where(t => t.UserName.Contains(param.UserName)).ToList() : list.ToList();

            //分页数据
            var data = query.Skip(param.Skip).Take(param.PageSize);

            //总页数
            var count = query.Count;

            var res = new PagerResult<User>
            {
                Code = 0,
                DataList = data,
                Total = count,
                PageSize = param.PageSize,
                PageIndex = param.PageIndex,
                RequestUrl = param.RequetUrl
            };
            return View(res);
        }

        //// GET: Users
        //public ActionResult Index1()
        //{
        //    var Users = db.Users.Include(u => u.Roles);
        //    return View(Users.ToList());
        //}

        //// GET: Users/Details/5
        //public ActionResult Details(int? id)
        //{
        //    if (id == null)
        //    {
        //        return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
        //    }
        //    User user = db.Users.Find(id);
        //    if (user == null)
        //    {
        //        return HttpNotFound();
        //    }
        //    return View(user);
        //}

        // 用户的增（由register代替）删改（由editrole、modify和changepassword代替）等操作
        // GET: Users/Create
        //public ActionResult Create()
        //{
        //    ViewBag.RoleID = new SelectList(db.Roles, "RoleID", "RoleName");
        //    return View();
        //}

        //// POST: Users/Create
        //// 为了防止“过多发布”攻击，请启用要绑定到的特定属性，有关 
        //// 详细信息，请参阅 http://go.microsoft.com/fwlink/?LinkId=317598。
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public ActionResult Create([Bind(Include = "UserID,UserName,RoleID,DisplayName,Password,Email,Status,RegistrationTime,LoginTime,LoginIP")] User user)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        //默认密码
        //        user.Password = Encode.Sha256("123456");
        //        db.Users.Add(user);
        //        db.SaveChanges();
        //        return RedirectToAction("Index");
        //    }

        //    return View(user);
        //}

        //// GET: Users/Edit/5
        //public ActionResult Edit(int? id)
        //{
        //    if (id == null)
        //    {
        //        return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
        //    }
        //    User user = db.Users.Find(id);
        //    if (user == null)
        //    {
        //        return HttpNotFound();
        //    }
        //    ViewBag.RoleID = new SelectList(db.Roles, "RoleID", "RoleName", user.RoleID);
        //    return View(user);
        //}

        //// POST: Users/Edit/5
        //// 为了防止“过多发布”攻击，请启用要绑定到的特定属性，有关 
        //// 详细信息，请参阅 http://go.microsoft.com/fwlink/?LinkId=317598。
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public ActionResult Edit([Bind(Include = "UserID,UserName,DisplayName,RoleID,Password,Email,Status,RegistrationTime,LoginTime,LoginIP")] User user)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        db.Entry(user).State = EntityState.Modified;
        //        db.SaveChanges();
        //        return RedirectToAction("Index");
        //    }
        //    ViewBag.RoleID = new SelectList(db.Roles, "RoleID", "RoleName", user.RoleID);
        //    return View(user);
        //}

        //// GET: Users/Delete/5
        //public ActionResult Delete(int? id)
        //{
        //    if (id == null)
        //    {
        //        return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
        //    }
        //    User user = db.Users.Find(id);
        //    if (user == null)
        //    {
        //        return HttpNotFound();
        //    }
        //    return View(user);
        //}

        //// POST: Users/Delete/5
        //[HttpPost, ActionName("Delete")]
        //[ValidateAntiForgeryToken]
        //public ActionResult DeleteConfirmed(int id)
        //{
        //    User user = db.Users.Find(id);
        //    db.Users.Remove(user);
        //    db.SaveChanges();
        //    return RedirectToAction("Index");
        //}

        #endregion

        #region 获取AuthenticationManager（认证管理器）
        /// <summary>
        /// 获取AuthenticationManager（认证管理器）
        /// </summary>
        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }
        #endregion

        #region 用户、角色以及授权管理

        /// <summary>
        /// 获取验证码图片
        /// </summary>
        /// <returns>验证码图片</returns>
        [AllowAnonymous]
        public ActionResult GetValidateCode()
        {
            ValidateCode vCode = new ValidateCode();
            string code = vCode.CreateValidateCode(4);
            Session["ValidateCode"] = code;
            byte[] bytes = vCode.CreateValidateGraphic(code);
            return File(bytes, @"image/jpeg");
        }

        /// <summary>
        /// 注册
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        public ActionResult Register()
        {
            return View();
        }

        /// <summary>
        /// 处理用户提交的注册数据POST
        /// </summary>
        /// <param name="register">UsersRegisterViewModel</param>
        /// <returns></returns>
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Register(UsersRegisterViewModel register)
        {
            if (register.VerificationCode == null || Session["ValidateCode"].ToString() != register.VerificationCode.ToUpper())
            {
                ModelState.AddModelError("VerificationCode", "验证码不正确");
                return View(register);
            }
            if (ModelState.IsValid)
            {
                if (udbr.Exist(u => u.UserName == register.UserName)) ModelState.AddModelError("UserName", "用户名已存在");
                else
                {
                    User _user = new User();
                    _user.UserName = register.UserName;
                    //默认用户组代码写这里
                    _user.RoleID = 1;
                    _user.DisplayName = register.DisplayName;
                    _user.Password = Encode.Sha256(register.Password);
                    //邮箱验证与邮箱唯一性问题
                    _user.Email = register.Email;
                    //用户状态问题
                    _user.Status = 0;
                    _user.RegistrationTime = DateTime.Now;
                    db.Users.Add(_user);
                    db.SaveChanges();
                    if (_user.UserID > 0)
                    {
                        AuthenticationManager.SignIn();
                        Content("注册成功！");
                        _user.LoginTime = DateTime.Now;
                        _user.LoginIP = Request.UserHostAddress;
                        db.Entry(_user).State = EntityState.Modified;
                        db.SaveChanges();
                        var _identity = authentication.CreateIdentity(_user, DefaultAuthenticationTypes.ApplicationCookie);
                        AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
                        AuthenticationManager.SignIn(_identity);
                        FormsAuthentication.SetAuthCookie(_user.UserName, false);
                        return Redirect(Url.Content("~/"));
                    }
                    else
                    {
                        ModelState.AddModelError("", "注册失败！");
                    }
                }
            }
            return View(register);
        }

        /// <summary>
        /// 用户登录
        /// </summary>
        /// <param name="returnUrl">返回Url</param>
        /// <returns></returns>
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        /// <summary>
        /// 用户登录逻辑POST
        /// </summary>
        /// 用ModelState.IsValid验证模型是否通过，没通过直接返回，通过则检查用户密码是否正确。用户名密码正确用CreateIdentity方法创建标识，然后用SignOut方法清空Cookies，然后用SignIn登录。
        /// <param name="loginViewModel">UsersLoginViewModel</param>
        /// <param name="returnUrl">返回Url</param>
        /// <returns></returns>
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(UsersLoginViewModel loginViewModel, string returnUrl)
        {
            if (ModelState.IsValid)
            {
                User _user = udbr.Find(u => u.UserName == loginViewModel.UserName);
                if (_user == null) ModelState.AddModelError("UserName", "用户名不存在");
                else if (_user.Password == Encode.Sha256(loginViewModel.Password))
                {
                    _user.LoginTime = DateTime.Now;
                    _user.LoginIP = Request.UserHostAddress;
                    udbr.Update(_user);
                    //db.Entry(_user).State = EntityState.Modified;
                    db.SaveChanges();
                    var _identity = authentication.CreateIdentity(_user, DefaultAuthenticationTypes.ApplicationCookie);
                    AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
                    AuthenticationManager.SignIn(new AuthenticationProperties() { IsPersistent = loginViewModel.RememberMe }, _identity);
                    FormsAuthentication.SetAuthCookie(_user.UserName, false);
                    if (returnUrl == null)
                    {
                        return Redirect(Url.Content("~/"));
                    }
                    else
                    {
                        return Redirect(returnUrl);
                    }

                }
                else ModelState.AddModelError("Password", "密码错误");
            }
            return View(loginViewModel);
        }

        /// <summary>
        /// 注销
        /// </summary>
        /// <returns></returns>
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return Redirect(Url.Content("~/"));
        }

        /// <summary>
        /// 显示用户资料
        /// </summary>
        /// <returns></returns>
        public ActionResult DataModify()
        {
            return View(udbr.Find(u => u.UserName == User.Identity.Name));
        }

        /// <summary>
        /// 修改资料
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Modify()
        {
            var _user = udbr.Find(u => u.UserName == User.Identity.Name);
            //var _user = db.Users.Find(User.Identity.Name);
            if (_user == null) ModelState.AddModelError("", "用户不存在");
            else
            {
                if (TryUpdateModel(_user, new string[] { "DisplayName", "Email" }))
                {
                    if (ModelState.IsValid)
                    {
                        db.Entry(_user).State = EntityState.Modified;
                        int sc = db.SaveChanges();
                        if (sc > 0)
                            ModelState.AddModelError("", "修改成功！");
                        else
                            ModelState.AddModelError("", "无需要修改的资料");
                    }
                }
                else ModelState.AddModelError("", "更新模型数据失败");
            }
            return Redirect(Url.Content("~/"));
        }

        /// <summary>
        /// 修改密码
        /// </summary>
        /// <returns></returns>
        public ActionResult ChangePassword()
        {
            User _user = udbr.Find(u => u.UserName == User.Identity.Name);
            UsersChangePasswordViewModel passwordViewModel = new UsersChangePasswordViewModel();
            passwordViewModel.UserName = _user.UserName;
            //passwordViewModel.Password = _user.Password;
            return PartialView("ChangePassword", passwordViewModel);
        }

        /// <summary>
        /// 修改密码POPST
        /// </summary>
        /// <param name="passwordViewModel">UsersChangePasswordViewModel</param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ChangePassword(UsersChangePasswordViewModel passwordViewModel)
        {
            if (ModelState.IsValid)
            {
                var _user = udbr.Find(u => u.UserName == passwordViewModel.UserName);
                //var _user = db.Users.Find(User.Identity.Name);
                if (_user.Password == Encode.Sha256(passwordViewModel.OriginalPassword))
                {
                    _user.Password = Encode.Sha256(passwordViewModel.Password);
                    db.Entry(_user).State = EntityState.Modified;
                    int sc = db.SaveChanges();
                    if (sc > 0)
                        ModelState.AddModelError("", "修改密码成功");
                    else
                        ModelState.AddModelError("", "修改密码失败");
                }
                else ModelState.AddModelError("", "原密码错误");
            }
            //return View(passwordViewModel);
            return Redirect(Url.Content("~/"));
        }

        /// <summary>
        /// 修改用户角色GET
        /// </summary>
        /// <param name="id">用户ID</param>
        /// <returns></returns>
        public ActionResult EditRole(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            User user = db.Users.Find(id);
            if (user == null)
            {
                return HttpNotFound();
            }
            ViewBag.RoleID = new SelectList(db.Roles, "RoleID", "RoleName", user.RoleID);
            return View(user);
        }

        /// <summary>
        /// 修改用户角色POST
        /// </summary>
        /// 为了防止“过多发布”攻击，请启用要绑定到的特定属性，有关 
        /// 详细信息，请参阅 http://go.microsoft.com/fwlink/?LinkId=317598。
        /// <param name="user">用户对象</param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditRole([Bind(Include = "UserID,UserName,DisplayName,RoleID,Password,Email,Status,RegistrationTime,LoginTime,LoginIP")] User user)
        {
            if (ModelState.IsValid)
            {
                db.Entry(user).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.RoleID = new SelectList(db.Roles, "RoleID", "RoleName", user.RoleID);
            return View(user);
        }

        #endregion

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

    }
}
