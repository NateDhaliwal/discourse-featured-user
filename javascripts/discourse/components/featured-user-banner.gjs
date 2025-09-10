import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import boundAvatar from "discourse/helpers/bound-avatar";
import UserAvatarFlair from "discourse/components/user-avatar-flair";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import UserStat from "discourse/components/user-stat";
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
  get showDaysVisited() { return settings.display_total_days_visited; }
  get showTotalPosts() { return settings.display_total_post_count; }
  get showTotalTopics() { return settings.display_total_topic_time; }
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

          <div class="top-section stats-section">
            <h3 class="stats-title">{{i18n "user.summary.stats"}}</h3>
            <ul>
              {{#if this.showDaysVisited}}
                <li class="stats-days-visited">
                  <UserStat
                    @value={{this.userSummary.days_visited}}
                    @label="user.summary.days_visited"
                  />
                </li>
              {{/if}}
              {{#if this.showReadTime}}
                <li class="stats-time-read">
                  <UserStat
                    @value={{this.userSummary.time_read}}
                    @label="user.summary.time_read"
                    @rawTitle={{i18n
                      "user.summary.time_read_title"
                      duration=this.userSummary.timeReadMedium
                    }}
                    @type="string"
                  />
                </li>
              {{/if}}
              <!--
              <li class="stats-posts-read">
                <UserStat
                  @value={{this.userSummary.posts_read_count}}
                  @label="user.summary.posts_read"
                />
              </li>
              -->
              {{#if this.showLikesGiven}}
                <li class="stats-likes-given">
                  <UserStat
                    @value={{this.userSummary.likes_given}}
                    @icon="heart"
                    @label="user.summary.likes_given"
                  />
                </li>
              {{/if}}
              <li class="stats-likes-received">
                <UserStat
                  @value={{this.userSummary.likes_received}}
                  @icon="heart"
                  @label="user.summary.likes_received"
                />
              </li>
              {{#if this.showTotalTopics}}
                <li class="stats-topic-count">
                  <UserStat
                    @value={{this.userSummary.topic_count}}
                    @label="user.summary.topic_count"
                  />
                </li>
              {{/if}}
              {{#if this.showTotalPosts}}
                <li class="stats-post-count">
                  <UserStat
                    @value={{this.userSummary.post_count}}
                    @label="user.summary.post_count"
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
