//
//  mark.h
//  SMark
//
//  Created by LawLincoln on 16/8/23.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

#ifndef mark_h
#define mark_h
#include "html.h"
#include "html_patch.h"
#include <stdio.h>

hoedown_renderer* smark_html_renderer(hoedown_html_flags flags, int rendererTOCLevel, hoedown_buffer *(*language_addition)(const hoedown_buffer *language, void *owner), void *owner);

hoedown_renderer* smark_toc_renderer(void *owner, int maxLevel);

void smark_free_renderer(hoedown_renderer *renderer);
#endif /* mark_h */
