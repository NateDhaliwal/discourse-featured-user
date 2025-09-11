import Component from "@glimmer/component";

import { apiInitializer } from "discourse/lib/api";
import { defaultHomepage } from "discourse/lib/utilities";
import { icon } from "discourse/helpers/d-icon";

import FeaturedUserBanner from "../components/featured-user-banner.gjs";

export default apiInitializer((api) => {
  api.renderInOutlet("above-main-container", FeaturedUserBanner);
  api.renderInOutlet(
    "user-card-after-username",
    class FeaturedUserIcon extends Component {
      get shouldShow() {
        return settings.featured_user_show_featured_icon_in_user_card && this.args.user.username === settings.featured_user.trim();
      }

      get iconNameFromSetting() {
        console.log(settings.featured_user_featured_icon_in_user_card);
        return settings.featured_user_featured_icon_in_user_card;
      }

      <template>
        {{#if this.shouldShow}}
          {{icon this.iconNameFromSetting}}
        {{/if}}
      </template>
    }
  );
});
