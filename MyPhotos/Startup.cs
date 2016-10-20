using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(MyPhotos.Startup))]
namespace MyPhotos
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
