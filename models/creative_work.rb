require_relative "./thing"

class CreativeWork < Thing
  attribute :accountable_person
  attribute :aggregate_rating
  attribute :alternative_headline
  attribute :associated_media
  attribute :author
  attribute :citation
  attribute :comment
  attribute :comment_count
  attribute :content_location
  attribute :content_rating
  attribute :contributor
  attribute :date_published, default: lambda{DateTime.now}
  attribute :educational_alignment
  attribute :headline
  attribute :inLanguage
  attribute :interaction_count
  attribute :interactivity_type
  attribute :is_based_on_url
  attribute :is_family_friendly
  attribute :license
  attribute :offers
  attribute :provider
  attribute :publisher
  attribute :review
  attribute :thumbnail_url
  attribute :version
  attribute :video
end