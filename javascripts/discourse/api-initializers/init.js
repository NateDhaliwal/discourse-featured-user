import { apiInitializer } from "discourse/lib/api";
import FeaturedUserBanner from "../components/featured-user-banner.gjs
  
export default apiInitializer((api) => {
  api.renderInOutlet(settings.banner_location, FeaturedUserBanner);
});
