require_relative './thing'

class Person < Thing
  # self.attributes = Thing.attributes
  #  + 
  #                  [:additional_name, :address, :affiliation, :alumni_of,
  #                   :award, :birth_date, :brand, :children, :colleague,
  #                   :contact_point, :death_date, :duns, :email, :family_name,
  #                   :fax_number, :follows, :gender, :given_name,
  #                   :global_location_number, :has_pos, :home_location,
  #                   :honorific_prefix, :honorific_suffix, :interaction_count,
  #                   :isic_v4, :job_title, :knows, :makes_offer, :member_of,
  #                   :naics, :nationality, :owns, :parent, :performer_in,
  #                   :related_to, :seeks, :sibling, :spouse, :tax_id,
  #                   :telephone, :vat_id, :work_location, :works_for]
  # self.attributes = [:_node_, :name, :born]
end