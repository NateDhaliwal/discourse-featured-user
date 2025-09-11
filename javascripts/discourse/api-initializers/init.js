import { apiInitializer } from "discourse/lib/api";
import FeaturedUserBanner from "../components/featured-user-banner.gjs";
import { defaultHomepage } from "discourse/lib/utilities";

export default apiInitializer((api) => {
  api.onPageChange((url, arg) => {
    console.log(url);
    api.renderInOutlet("above-main-container", FeaturedUserBanner);
  });
});
