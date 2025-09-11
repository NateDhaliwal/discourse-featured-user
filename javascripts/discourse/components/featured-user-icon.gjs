import Component from "@glimmer/component";
import { defaultHomepage } from "discourse/lib/utilities";
import icon from "discourse/helpers/d-icon";
import DTooltip from "float-kit/components/d-tooltip";
import { i18n } from "discourse-i18n";

export default class FeaturedUserIcon extends Component {
  get shouldShow() {
    return settings.featured_user_show_featured_icon_in_user_card && this.args.user.username === settings.featured_user.trim();
  }

  get iconNameFromSetting() {
    return settings.featured_user_featured_icon_in_user_card;
  }

  <template>
    {{#if this.shouldShow}}
      <span class="featured-user-card-icon">
        <DTooltip
          @icon={{this.iconNameFromSetting}}
          @content={{i18n (themePrefix "user_card.featured_user_icon")}}
        />
      </span>
    {{/if}}
  </template>
}
