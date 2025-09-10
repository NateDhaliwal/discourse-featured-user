import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import boundAvatar from "discourse/helpers/bound-avatar";
import UserAvatarFlair from "discourse/components/user-avatar-flair";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import { ajax } from "discourse/lib/ajax";
import User from "discourse/models/user";
import formatDuration from "discourse/helpers/format-duration";

export default class FeaturedUserBanner extends Component {
  @tracked userModel;
  @tracked user;
  @tracked loading = true;

  // Add checking with timestamps one day?
  startDate = new Date(settings.featured_user_banner_display_start_date.trim());
  endDate = new Date(settings.featured_user_banner_display_end_date.trim());
  dateNow = new Date(Date.now());

  constructor() {
    super(...arguments);
    this.getUser();
  }

  get shouldShow() {
    console.log(this.user);
    console.log(this.userModel);
    return this.startDate <= this.dateNow && this.dateNow <= this.endDate;
  }

  get showAvatar() { return settings.display_avatar; }
  get showAvatarFlair() { return settings.display_flair; }
  get showReadTime() { return settings.display_total_read_time; }

  async getUser() {
    const userData = await ajax(`/u/${settings.featured_user.trim()}`);
    this.user = userData.user;
    const userModelData = await User.findByUsername(settings.featured_user.trim());
    this.userModel = userModelData;
    this.loading = false;
  }




















  <template>
    {{#if this.shouldShow}}
      {{#if this.loading}}
        <ConditionalLoadingSpinner @condition={{this.loading}} />
      {{else}}
        <div class="user-card-avatar" style="width: var(--avatar-width);" aria-hidden="true">
          {{#if this.showAvatar}}
            <a
              href={{this.userModel.path}}
              class="card-huge-avatar"
              tabindex="-1"
            >{{boundAvatar this.user "huge"}}</a>
          {{/if}}

          {{#if this.showAvatarFlair}}
            <UserAvatarFlair @user={{this.user}} />
          {{/if}}

          {{#if this.showReadTime}}
            <span class="desc">{{i18n "time_read"}}</span>
            {{formatDuration this.user.time_read}}
          {{/if}}
        </div>
      {{/if}}
    {{/if}}
  </template>
}
