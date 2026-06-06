--!nonstrict
--[=[
	@class LocalizationServiceUtils
]=]

const LocalizationService = game:GetService('LocalizationService')
const RunService = game:GetService('RunService')

const Promise = require('../roblox_packages/Promise')
const PromiseMaidUtils = require('../roblox_packages/PromiseMaidUtils')

local TIMEOUT = 20
if RunService:IsStudio() then
	TIMEOUT = 0.5
end

const ERROR_PUBLISH_REQUIRED = 'Publishing the game is required to use GetTranslatorForPlayerAsync API.'
const ERROR_TIMEOUT = string.format('GetTranslatorForPlayerAsync is still pending after %f, using local table', TIMEOUT)

const LocalizationServiceUtils = {}

@checked
function LocalizationServiceUtils.promiseTranslatorForLocale(localeId)
	return Promise.spawn(function(resolve, reject)
		local translator = nil
		local ok, err = pcall(function()
			translator = LocalizationService:GetTranslatorForLocaleAsync(localeId)
		end)

		if not ok then
			return reject(err or 'Failed to GetTranslatorForLocaleAsync')
		end

		if typeof(translator) ~= 'Instance' then
			return reject('Translator was not returned')
		end

		return resolve(translator)
	end)
end

@checked
function LocalizationServiceUtils.promisePlayerTranslator(player: Player)
	local promiseTranslator = Promise.spawn(function(resolve, reject)
		local translator = nil
		local ok, err = pcall(function()
			translator = LocalizationService:GetTranslatorForPlayerAsync(player)
		end)

		if not ok then
			return reject(err or 'Failed to GetTranslatorForPlayerAsync')
		end

		if typeof(translator) ~= 'Instance' then
			return reject('Translator was not returned')
		end

		return resolve(translator)
	end)

	PromiseMaidUtils.whilePromise(promiseTranslator, function(maid)
		maid:GiveTask(task.delay(TIMEOUT, function()
			promiseTranslator:Reject(ERROR_TIMEOUT)
		end))
	end)

	return promiseTranslator:Catch(function(err)
		if err ~= ERROR_PUBLISH_REQUIRED and error ~= ERROR_TIMEOUT then
			warn(string.format('[LocalizationServiceUtils.promisePlayerTranslator] - %s', tostring(err)))
		end

		-- Fallback to just local stuff
		local translator = LocalizationService:GetTranslatorForPlayer(player)
		return translator
	end)
end

return LocalizationServiceUtils
