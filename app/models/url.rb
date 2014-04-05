class Url < ActiveRecord::Base
    scope :recent, -> { order(created_at: :desc) }

    validates :long, presence: true, uniqueness: { case_sensitive: true }, url: true

    def self.has_url(url)
        return where(long: url).present?
    end

    def self.get_from_long(long)
        where(long: long).first
    end

    def self.get_from_short(short)
        id = Bijective::Encoder.decode(short)
        find(id)
    end

    def short
        Bijective::Encoder.encode(id)
    end

    def duplicate?
        return false unless new_record?
        return true if Url.has_url(long)
    end

    def to_param
        short
    end
end
