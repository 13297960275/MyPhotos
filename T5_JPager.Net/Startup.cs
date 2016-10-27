using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(T5_JPager.Net.Startup))]
namespace T5_JPager.Net
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
