import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import boundAvatar from "discourse/helpers/bound-avatar";
import UserAvatarFlair from "discourse/components/user-avatar-flair";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import { ajax } from "discourse/lib/ajax";
import { and } from "truth-helpers";
import User from "discourse/models/user";
import formatDuration from "discourse/helpers/format-duration";
import { i18n } from "discourse-i18n";

export default class FeaturedUserBanner extends Component {
  @tracked user;
  @tracked userSummary;
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
    return this.startDate <= this.dateNow && this.dateNow <= this.endDate;
  }

  get showAvatar() { return settings.display_avatar; }
  get showAvatarFlair() { return settings.display_flair; }
  get showReadTime() { return settings.display_total_read_time; }
  get showTotalPosts() { return settings.display_total_post_count; }
  get showTotalTopics() { return settings.display_total_topic_time; }
  get showLikesGiven() { return settings.display_total_likes_given; }
  get showLikesReceived() { return settings.display_total_likes_received; }

  async getUser() {
    const userData = await ajax(`/u/${settings.featured_user.trim()}`);
    this.user = userData.user;
    const userSummaryData = await ajax(`/u/%{settings.featured_user.trim()}`);
    this.userSummary = summaryData;
    this.loading = false;
  }

  get userProfileURL() {
    return `/u/${this.user.username}`;
  }

  <template>
    {{#if this.shouldShow}}
      {{#if this.loading}}
        <ConditionalLoadingSpinner @condition={{this.loading}} />
      {{else}}
        <div class="featured-user-banner">
          {{#if this.showAvatar}}
            <div class="user-avatar" style="max-height: 8em; width: 8em;" aria-hidden="true">
              <a
                href={{this.userProfileURL}}
                class="card-huge-avatar"
                tabindex="-1"
              >{{boundAvatar this.user "huge"}}</a>
              {{#if this.showAvatarFlair}}
                <UserAvatarFlair @user={{this.user}} />
              {{/if}}
            </div>
          {{/if}}

          <div class="user-stats">
            <div class="user-stats-row" style="order: 1;">
              {{#if this.showReadTime}}
                <span class="desc">{{i18n "time_read"}}</span>
                {{formatDuration this.user.time_read}}
              {{/if}}
            </div>
            <div class="user-stats-row" style="order: 2;">
              {{#if this.showTotalPosts}}
                <span class="desc">{{i18n "time_read"}}</span>
                {{formatDuration this.user.time_read}}
              {{/if}}
            </div>
            
          </div>
        </div>
      {{/if}}
    {{/if}}
  </template>
}
