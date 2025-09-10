import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import boundAvatar from "discourse/helpers/bound-avatar";
import UserAvatarFlair from "discourse/components/user-avatar-flair";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import { ajax } from "discourse/lib/ajax";
import User from "discourse/models/user";

export default class FeaturedUserBanner extends Component {
  @tracked userModel;
  @tracked user;
  @tracked loading = false;

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

  async getUser() {
    const userData = await ajax(`/u/${settings.featured_user.trim()}`);
    this.user = userData.user;
    const userModelData = await User.findByUsername(settings.featured_user.trim());
    this.userModel = userModelData;
    this.loading = true;
  }




















  <template>
    {{#if this.shouldShow}}
      {{#if this.loading}}
        <ConditionalLoadingSpinner @condition={{this.loading}} />
      {{else}}
        <div class="user-card-avatar" aria-hidden="true">
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
        </div>
      {{/if}}
    {{/if}}
  </template>
}
