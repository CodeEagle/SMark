//
//  mark.c
//  SMark
//
//  Created by LawLincoln on 16/8/23.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

#include "mark.h"
hoedown_renderer* smark_html_renderer(hoedown_html_flags flags, int rendererTOCLevel, hoedown_buffer *(*language_addition)(const hoedown_buffer *language, void *owner), void *owner) {
    
    hoedown_renderer *htmlRenderer = hoedown_html_renderer_new(flags, rendererTOCLevel);
    htmlRenderer->blockcode = hoedown_patch_render_blockcode;
    htmlRenderer->listitem = hoedown_patch_render_listitem;
    
    hoedown_html_renderer_state_extra *extra = hoedown_malloc(sizeof(hoedown_html_renderer_state_extra));
    extra->language_addition = language_addition;
    extra->owner = owner;
    
    ((hoedown_html_renderer_state *)htmlRenderer->opaque)->opaque = extra;
    return htmlRenderer;
}

hoedown_renderer* smark_toc_renderer(void *owner, int maxLevel) {
    hoedown_renderer *tocRenderer = hoedown_html_toc_renderer_new(maxLevel);
    tocRenderer->header = hoedown_patch_render_toc_header;
    return tocRenderer;
}

void smark_free_renderer(hoedown_renderer *renderer) {
    hoedown_html_renderer_state_extra *extra =
    ((hoedown_html_renderer_state *)renderer->opaque)->opaque;
    if (extra) { free(extra); }
    hoedown_html_renderer_free(renderer);
}