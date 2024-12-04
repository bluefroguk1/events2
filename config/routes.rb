# frozen_string_literal: true

DiscourseEvents::Engine.routes.draw do
  post "/rsvp/add" => "rsvp#add"
  post "/rsvp/remove" => "rsvp#remove"
  get "/api-keys" => "api_keys#index"
  get "/rsvp/users" => "rsvp#users"
end

Discourse::Application.routes.prepend do
  get "calendar.ics" => "list#calendar_ics", :format => :ics, :protocol => :webcal
  get "calendar.rss" => "list#calendar_feed", :format => :rss
  get "agenda.rss" => "list#agenda_feed", :format => :rss

  %w[users u].each do |root_path|
    get "#{root_path}/:username/preferences/webcal-keys" => "users#preferences",
        :constraints => {
          username: RouteFormat.username,
        }
  end

  get "c/*category_slug_path_with_id/l/calendar.ics" => "list#calendar_ics",
      :format => :ics,
      :protocol => :webcal
  get "c/*category_slug_path_with_id/l/calendar.rss" => "list#calendar_feed", :format => :rss
  get "c/*category_slug_path_with_id/l/agenda.rss" => "list#agenda_feed", :format => :rss

  mount ::DiscourseEvents::Engine, at: "/discourse-events"

  scope module: "discourse_events", constraints: AdminConstraint.new do
    scope "/admin/plugins" do
      get "events" => "admin#index"
      get "events/provider" => "provider#index"
      put "events/provider/new" => "provider#create"
      put "events/provider/:id" => "provider#update"
      get "events/provider/:id/authorize" => "provider#authorize"
      get "events/provider/redirect" => "provider#redirect"
      delete "events/provider/:id" => "provider#destroy"
      get "events/source" => "source#index"
      put "events/source/new" => "source#create"
      put "events/source/:id" => "source#update"
      post "events/source/:id" => "source#import"
      delete "events/source/:id" => "source#destroy"
      get "events/connection" => "connection#index"
      put "events/connection/new" => "connection#create"
      put "events/connection/:id" => "connection#update"
      post "events/connection/:id" => "connection#sync"
      delete "events/connection/:id" => "connection#destroy"
      get "events/event" => "event#index"
      delete "events/event" => "event#destroy"
      get "events/log" => "log#index"
    end
  end
end
