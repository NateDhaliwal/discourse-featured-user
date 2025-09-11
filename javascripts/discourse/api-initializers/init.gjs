import { apiInitializer } from "discourse/lib/api";
import FeaturedUserBanner from "../components/featured-user-banner";
import FeaturedUserIcon from "../components/featured-user-icon";

export default apiInitializer((api) => {
  api.renderInOutlet("above-main-container", FeaturedUserBanner);
  api.renderInOutlet("user-card-after-username", FeaturedUserIcon);
});
