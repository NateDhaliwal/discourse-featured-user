import { on } from "@ember/modifier";
import Component from "@glimmer/component";
import boundAvatar from "discourse/helpers/bound-avatar";

export default class FeaturedUserBanner extends Component {
  static shouldRender(args) {
    
  }
}
























<template>
<div class="user-card-avatar" aria-hidden="true">
  {{#if this.contentHidden}}
    <span class="card-huge-avatar">{{boundAvatar
        this.user
        "huge"
      }}</span>
  {{else}}
    <a
      {{on "click" this.handleShowUser}}
      href={{this.user.path}}
      class="card-huge-avatar"
      tabindex="-1"
    >{{boundAvatar this.user "huge"}}</a>
  {{/if}}

  <UserAvatarFlair @user={{this.user}} />

  <div>
    <PluginOutlet
      @name="user-card-avatar-flair"
      @connectorTagName="div"
      @outletArgs={{lazyHash user=this.user}}
    />
  </div>
</div>
</template>
