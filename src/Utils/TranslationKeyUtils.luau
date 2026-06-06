--!strict
--[=[
	@class TranslationKeyUtils
]=]

const String = require('../roblox_packages/Stringutils')

const TranslationKeyUtils = {}

--[=[
	Converts a string to a translation key in a fixed format, with a maximum length

	@param prefix string
	@param text string
	@return string
]=]
@checked
function TranslationKeyUtils.getTranslationKey(prefix: string, text: string): string
	local firstWordsBeginning = string.sub(string.gsub(text, '%s', ''), 1, 20)
	local firstWords = String.toLowerCamelCase(firstWordsBeginning)

	return prefix .. '.' .. firstWords
end

return TranslationKeyUtils
