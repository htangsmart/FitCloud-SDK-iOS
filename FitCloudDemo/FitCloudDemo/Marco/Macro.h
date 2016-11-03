//
//  Macro.h
//  FitCloudDemo
//
//  Created by 远征 马 on 2016/10/31.
//  Copyright © 2016年 马远征. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define WS(ws) __weak __typeof(self)ws = self;
#define SS(ss) __strong __typeof(ws)ss = ws;

#endif /* Macro_h */
