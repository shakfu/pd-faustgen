///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Simple synthetizer that use sy.dubDub of the standard Faust library.
// The frequency is modulated by a 1 octave keyboard
// The 2 filter's parameters are modulated by a 2d array (Trill Craft sensor)
// A checkbox active the buffering of the parameters value.
//
///////////////////////////////////////////////////////////////////////////////////////////////////
// Trill Sensor implementation:
//
// this sample use :
//  - 1 craft sensor for the 1 octave keyboard and some control touch
//  - 1 square sensor for the control of the 2 Filter parameters cut off frequency & Q
//
import("stdfaust.lib");
// Sensor Configuration //////////////////////////////////////////////////
declare trill_mappings "{ 'SQUARE' : {'0' : 40 } ; 'CRAFT' : {'0' : 48} }";             //i2c address for each trill sensor
declare trill_settings "{ 'CRAFT_0' : { 'prescaler' : 4 ; 'threshold' : 0.015 }}";      //sensibility settings for the crafts sensors

// Parameter Configuration //////////////////////////////////////////////////
//Monophonic keyboard
nokey = hslider("note [TRILL:CRAFT_0 UP 15-27]", -1, -1, 11, 1);  //one octave keyboard   

// Filter
CUTOFF_MIN = 350; //minimum value of cut off frequency
Q_MIN = 0.8;
touchsqsensor = (button("touch[TRILL:SQUARE_LVL_0]") > 0.1);    //square sensor pressed
buffering = (checkbox("buffering[TRILL:CRAFT_0 PIN 0]") == 0);  //activation of buffering of the filter's parameters values
ctfreq = hslider("cutoff freq [TRILL:SQUARE_XPOS_0]", CUTOFF_MIN, CUTOFF_MIN, 2000, 0.1) : ba.bypass1(buffering, max(CUTOFF_MIN, ba.sAndH(touchsqsensor))) : si.smoo;       //value of the trill x square sensor for cut off frequency
q = hslider("Q [TRILL:SQUARE_YPOS_0]", Q_MIN, Q_MIN, 10, 0.001): ba.bypass1(buffering, max(Q_MIN, ba.sAndH(touchsqsensor))) : si.smoo;                                      //value of the trill y square sensor for Q

// Process  //////////////////////////////////////////////////
START_NOTE = 130.81; // C2
freq = (START_NOTE * pow(2, (max(0, nokey) / 12)));
gate = min(1, (nokey + 1));

process = sy.dubDub(freq, ctfreq, q, gate) * 0.5;