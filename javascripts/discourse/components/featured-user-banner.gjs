import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import boundAvatar from "discourse/helpers/bound-avatar";
import UserAvatarFlair from "discourse/components/user-avatar-flair";
import UserProfileAvatar from "discourse/components/user-profile-avatar";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import UserStat from "discourse/components/user-stat";
import { ajax } from "discourse/lib/ajax";
import { eq, notEq } from "truth-helpers";
import User from "discourse/models/user";
import formatDuration from "discourse/helpers/format-duration";
import { i18n } from "discourse-i18n";
import formatUsername from "discourse/helpers/format-username";

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
    return this.startDate <= this.dateNow && this.dateNow <= this.endDate;
  }

  get showReadTime() { return settings.display_total_read_time; }
  get showDaysVisited() { return settings.display_total_days_visited; }
  get showTotalPosts() { return settings.display_total_post_count; }
  get showTotalTopics() { return settings.display_total_topic_count; }
  get showLikesGiven() { return settings.display_total_likes_given; }
  get showLikesReceived() { return settings.display_total_likes_received; }

  get featuredUserBannerText() { return settings.featured_user_banner_text; }
  get featuredUserBannerTextPosition() { return settings.featured_user_banner_text_position == "below-user-info" ? "below" : "after"; }

  async getUser() {
    const userData = await ajax(`/u/${settings.featured_user.trim()}`);
    this.user = userData.user;
    const userSummaryData = await ajax(`/u/${settings.featured_user.trim()}/summary`);
    this.userSummary = userSummaryData.user_summary;
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
          {{#if (eq this.featuredUserBannerTextPosition "above"}}
            <div class="featured-banner-text-above">
              <h2>{{this.featuredUserBannerText}}</h2>
            </div>
          {{/if}}
          <div class="user-info">
            <div class="details">
              <div class="user-info-avatar">
                <UserProfileAvatar @user={{this.user}} @tagName="user-info-avatar" />
              </div>
              <div class="primary-textual">
                <div class="user-profile-names">
                  <div
                    class="username user-profile-names__primary"
                  >
                    {{formatUsername this.user.username}}
                  </div>

                  {{#if (notEq this.user.name "")}}
                    <div class="name">
                      <h3>{{this.user.name}}</h3>
                    </div>
                  {{/if}}

                  {{#if this.user.title}}
                    <div
                      class="user-profile-names__title"
                    >{{this.user.title}}</div>
                  {{/if}}
                </div>
              </div>
            </div>
          </div>

          <div class="user-stats-section stats-section top-section">
            <h3 class="stats-title">{{i18n "user.summary.stats"}}</h3>
            <ul>
              {{#if this.showDaysVisited}}
                <li class="stats-days-visited">
                  <UserStat
                    @value={{this.userSummary.days_visited}}
                    @label={{if (eq this.userSummary.days_visited 1) "user.summary.days_visited.other" "user.summary.days_visited.other"}}
                  />
                </li>
              {{/if}}
              {{#if this.showReadTime}}
                <li class="stats-time-read">
                  <UserStat
                    @value={{formatDuration this.userSummary.time_read}}
                    @label="user.summary.time_read"
                    @rawTitle={{i18n
                      "user.summary.time_read_title"
                      duration=this.userSummary.time_read
                    }}
                    @type="string"
                  />
                </li>
              {{/if}}
              {{#if this.showLikesGiven}}
                <li class="stats-likes-given">
                  <UserStat
                    @value={{this.userSummary.likes_given}}
                    @icon="heart"
                    @label={{if (eq this.userSummary.likes_given 1) "user.summary.likes_given.one" "user.summary.likes_given.other"}}
                  />
                </li>
              {{/if}}
              {{#if this.showLikesReceived}}
                <li class="stats-likes-received">
                  <UserStat
                    @value={{this.userSummary.likes_received}}
                    @icon="heart"
                    @label={{if (eq this.userSummary.likes_received 1) "user.summary.likes_received.one" "user.summary.likes_received.other"}}
                  />
                </li>
              {{/if}}
              {{#if this.showTotalTopics}}
                <li class="stats-topic-count">
                  <UserStat
                    @value={{this.userSummary.topic_count}}
                    @label={{if (eq this.userSummary.topic_count 1) "user.summary.topic_count.one" "user.summary.topic_count.other"}}
                  />
                </li>
              {{/if}}
              {{#if this.showTotalPosts}}
                <li class="stats-post-count">
                  <UserStat
                    @value={{this.userSummary.post_count}}
                    @label={{if (eq this.userSummary.post_count 1) "user.summary.post_count.one" "user.summary.post_count.other"}}
                  />
                </li>
              {{/if}}
            </ul>
          </div>
          {{#if (eq this.featuredUserBannerTextPosition "below"}}
            <div class="featured-banner-text-below">
              <h2>{{this.featuredUserBannerText}}</h2>
            </div>
          {{/if}}
        </div>
      {{/if}}
    {{/if}}
  </template>
}
