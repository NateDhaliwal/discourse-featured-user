import { apiInitializer } from "discourse/lib/api";
import FeaturedUserBanner from "../components/featured-user-banner.gjs";
import { defaultHomepage } from "discourse/lib/utilities";

export default apiInitializer((api) => {
  const router = api.container.lookup("service:router");
  const { currentRouteName } = router;
  console.log(router);
  console.log(`discovery.${defaultHomepage()}`);
  console.log(currentRouteName);
  console.log(currentRouteName === `discovery.${defaultHomepage()}`);
  if (currentRouteName === `discovery.${defaultHomepage()}`) {
    api.renderInOutlet("above-main-container", FeaturedUserBanner);
  }
});
