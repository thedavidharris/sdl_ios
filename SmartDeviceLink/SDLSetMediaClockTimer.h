//  SDLSetMediaClockTimer.h
//

#import "SDLRPCRequest.h"

#import "SDLUpdateMode.h"
#import "SDLAudioStreamingIndicator.h"

@class SDLStartTime;

/**
 * Sets the media clock/timer value and the update method (e.g.count-up,
 * count-down, etc.)
 * <p>
 * Function Group: Base <p>
 * <b>HMILevel needs to be FULL, LIMITIED or BACKGROUND</b>
 * </p>
 *
 * Since SmartDeviceLink 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSetMediaClockTimer : SDLRPCRequest

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode hours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds audioStreamingIndicator:(SDLAudioStreamingIndicator)audioStreamingIndicator;

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode hours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds;

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode;

/**
 * A Start Time with specifying hour, minute, second values
 *
 * @discussion A startTime object with specifying hour, minute, second values
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>If "updateMode" is COUNTUP or COUNTDOWN, this parameter
 *            must be provided</li>
 *            <li>Will be ignored for PAUSE/RESUME and CLEAR</li>
 *            </ul>
 */
@property (strong, nonatomic, nullable) SDLStartTime *startTime;
/**
 * An END time of type SDLStartTime, specifying hour, minute, second values
 *
 * @discussion An SDLStartTime object with specifying hour, minute, second values
 */
@property (strong, nonatomic, nullable) SDLStartTime *endTime;
/**
 * The media clock/timer update mode (COUNTUP/COUNTDOWN/PAUSE/RESUME)
 *
 * @discussion a Enumeration value (COUNTUP/COUNTDOWN/PAUSE/RESUME)
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>When updateMode is PAUSE, RESUME or CLEAR, the start time value
 *            is ignored</li>
 *            <li>When updateMode is RESUME, the timer resumes counting from
 *            the timer's value when it was paused</li>
 *            </ul>
 */
@property (strong, nonatomic) SDLUpdateMode updateMode;

/**
 * The audio streaming indicator used for a play/pause button.
 *
 * @discussion Set the indicator icon of a play/pause button depending on the
 * current audio playback. This parameter is optional. If omitted the last indicator sent
 * will not change.
 */
@property (strong, nonatomic, nullable) SDLAudioStreamingIndicator audioStreamingIndicator;


@end

NS_ASSUME_NONNULL_END
