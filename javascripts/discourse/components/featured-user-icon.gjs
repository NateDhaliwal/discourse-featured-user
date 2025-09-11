import Component from "@glimmer/component";
import { i18n } from "discourse-i18n";
import DTooltip from "float-kit/components/d-tooltip";

export default class FeaturedUserIcon extends Component {
  // Add checking with timestamps one day?
  startDate = new Date(settings.featured_user_banner_display_start_date.trim());
  endDate = new Date(settings.featured_user_banner_display_end_date.trim());
  dateNow = new Date(Date.now());

  get withinDates() {
    return this.startDate <= this.dateNow && this.dateNow <= this.endDate;
  }

  get shouldShow() {
    return (
      settings.featured_user_show_featured_icon_in_user_card &&
      this.args.user.username === settings.featured_user.trim() &&
      this.withinDates
    );
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
