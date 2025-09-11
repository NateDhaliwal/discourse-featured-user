import { apiInitializer } from "discourse/lib/api";
import FeaturedUserBanner from "../components/featured-user-banner.gjs";
import { defaultHomepage } from "discourse/lib/utilities";

export default apiInitializer((api) => {
  const router = api.container.lookup("service:router");
  console.log(`discovery.${defaultHomepage()}`);
  console.log(router.currentRouteName === `discovery.${defaultHomepage()}`);
  if (router.currentRouteName === `discovery.${defaultHomepage()}`) {
    api.renderInOutlet("above-main-container", FeaturedUserBanner);
  }
});
