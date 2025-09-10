import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import boundAvatar from "discourse/helpers/bound-avatar";
import UserAvatarFlair from "discourse/components/user-avatar-flair";
import UserProfileAvatar from "discourse/components/user-profile-avatar";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import UserStat from "discourse/components/user-stat";
import { ajax } from "discourse/lib/ajax";
import { and } from "truth-helpers";
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
    console.log(this.user);
    return this.startDate <= this.dateNow && this.dateNow <= this.endDate;
  }

  get showReadTime() { return settings.display_total_read_time; }
  get showDaysVisited() { return settings.display_total_days_visited; }
  get showTotalPosts() { return settings.display_total_post_count; }
  get showTotalTopics() { return settings.display_total_topic_count; }
  get showLikesGiven() { return settings.display_total_likes_given; }
  get showLikesReceived() { return settings.display_total_likes_received; }

  async getUser() {
    const userData = await ajax(`/u/${settings.featured_user.trim()}`);
    this.user = userData.user;
    const userSummaryData = await ajax(`/u/${settings.featured_user.trim()}`);
    this.userSummary = userSummaryData;
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
          <!--
          <div class="user-avatar" aria-hidden="true">
            <a
              href={{this.userProfileURL}}
              class="card-huge-avatar"
              tabindex="-1"
            >{{boundAvatar this.user "huge"}}</a>
            <UserAvatarFlair @user={{this.user}} />
          </div>
          -->
          <div class="user-info">
            <div class="details">
              <div class="primary">
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
                    {{#if this.user.title}}
                      <div
                        class="user-profile-names__title"
                      >{{this.user.title}}</div>
                    {{/if}}
                  </div>
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
                    @label={{i18n "user.summary.days_visited"}}
                  />
                </li>
              {{/if}}
              {{#if this.showReadTime}}
                <li class="stats-time-read">
                  <UserStat
                    @value={{this.userSummary.time_read}}
                    @label={{i18n "user.summary.time_read"}}
                    @rawTitle={{i18n
                      "user.summary.time_read_title"
                      duration=this.userSummary.timeReadMedium
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
                    @label={{i18n "user.summary.likes_given"}}
                  />
                </li>
              {{/if}}
              {{#if this.showLikesReceived}}
                <li class="stats-likes-received">
                  <UserStat
                    @value={{this.userSummary.likes_received}}
                    @icon="heart"
                    @label={{i18n "user.summary.likes_received"}}
                  />
                </li>
              {{/if}}
              {{#if this.showTotalTopics}}
                <li class="stats-topic-count">
                  <UserStat
                    @value={{this.userSummary.topic_count}}
                    @label={{i18n "user.summary.topic_count"}}
                  />
                </li>
              {{/if}}
              {{#if this.showTotalPosts}}
                <li class="stats-post-count">
                  <UserStat
                    @value={{this.userSummary.post_count}}
                    @label={{i18n "user.summary.post_count"}}
                  />
                </li>
              {{/if}}
            </ul>
          </div>
        </div>
      {{/if}}
    {{/if}}
  </template>
}
