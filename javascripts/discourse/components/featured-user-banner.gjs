import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import boundAvatar from "discourse/helpers/bound-avatar";
import UserAvatarFlair from "discourse/components/user-avatar-flair";
import User from "discourse/models/user";

export default class FeaturedUserBanner extends Component {
  @tracked user = User.findByUsername(settings.featured_user.trim());

  // Add checking with timestamps one day?
  startDate = new Date(settings.featured_user_banner_display_start_date.trim());
  endDate = new Date(settings.featured_user_banner_display_end_date.trim());
  dateNow = new Date(Date.now());

  get shouldShow() {
    console.log(this.user);
    return this.startDate <= this.dateNow && this.dateNow <= this.endDate;
  }

  get showAvatar() { return settings.display_avatar; }
  get showAvatarFlair() { return settings.display_flair; }






















  <template>
    {{#if this.shouldShow}}
      <div class="user-card-avatar" aria-hidden="true">
        {{#if this.showAvatar}}
          <a
            href={{this.user.path}}
            class="card-huge-avatar"
            tabindex="-1"
          >{{boundAvatar this.user "huge"}}</a>
        {{/if}}
  
        {{#if this.showAvatarFlair}}
          <UserAvatarFlair @user={{this.user}} />
        {{/if}}
      </div>
    {{/if}}
  </template>
}
