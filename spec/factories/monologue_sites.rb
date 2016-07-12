# encoding: UTF-8
# frozen_string_literal: true
FactoryGirl.define do
  factory :site, class: Monologue::Site do
    sequence(:name) { |i| "test site name #{i}" }
    sequence(:domain) { |i| "127.0.0.#{i}.xip.io" }
    locale :en
  end
end
