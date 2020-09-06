"""Convertace article with TEX syntax with Hatena Blog Syntax """
import os
import re
from typing import List, Callable
from copy import deepcopy


def replace_m(x: str, rep_map: List[dict]) -> str:
    for pattern, repl in rep_map:
        x = x.replace(pattern, repl)
    return x

def add_tags(x: str, tag_pre: str, tag_post: str) -> str:
    """Concatenate string and tags"""
    return tag_pre + x + tag_post


class ConvertHatenaTex:
    """Convert TEX syntax to Hatena Blog TEX Syntax.

    """

    def __init__(self):

        self.pattern_block = r'\$\$([\S\s]*?)\$\$'
        self.pattern_inline = r'\$([a-zA-Z0-9!-/:-@¥[-`{-~ ]+)\$'

        self.rep_map_block = [
                            ('[', r'\['),
                            (']', r'\]'),
                            ('<', r'\lt'),
                            ]
        self.rep_map_inline = [
                                ('[', r'\\['),
                                (']', r'\\]'),
                                ('_', r'\_'),
                                ('^', '^ '),
                                (r'\{', r'\\{'),
                                (r'\}', r'\\}'),
                                ('<', r'\lt'),
                                ]

        tag_pre_b = '<div  align="center">\n[tex:\displaystyle{\n\n'
        tag_post_b = '\n}]\n</div>\n'

        # tag_pre_b = '<pre>\n[tex:\n\n'
        # tag_post_b = '\n]\n</pre>\n'

        self.tags_block = (tag_pre_b, tag_post_b)

        tag_pre_i = '[tex:\displaystyle{'
        tag_post_i = '}]'

        # tag_pre_i = '[tex:'
        # tag_post_i = ']'

        self.tags_inline = (tag_pre_i, tag_post_i)

    def replace(self, artile_strings: str) -> str:
        x = deepcopy(artile_strings)
        x = self._replace(x, self.pattern_block, self.proc_in_blocks)
        x = self._replace(x, self.pattern_inline, self.proc_in_lines)
        return x

    def proc_in_blocks(self, x: str) -> str:
        """Process replacing lines in blocks"""
        x = replace_m(x, self.rep_map_block)
        x = add_tags(x, *self.tags_block)
        return x

    def proc_in_lines(self, x: str) -> str:
        """Process replacing in lines"""
        x = replace_m(x, self.rep_map_inline)
        x = add_tags(x, *self.tags_inline)
        return x

    def _replace(self, artile_strings: str, pattern: str,
                            rep_func: Callable[[str], str]) -> str:
        """Extract block/inline parts and replace"""
        prog = re.compile(pattern)
        results = prog.finditer(artile_strings)

        replace_strs = []
        n_init = 0
        for mg in results:

            str_chunk = mg.group(1)

            str_chunk = rep_func(str_chunk)

            n_start, n_end = mg.span()
            str_pre = artile_strings[n_init:n_start]

            replace_strs.append(str_pre)
            replace_strs.append(str_chunk)
            n_init = n_end

        replace_strs.append(artile_strings[n_end:])
        artile_strings_new = ''.join(replace_strs)

        return artile_strings_new



if __name__ == '__main__':

    # art_nm = '200810_whitenoise_iid.md'
    # art_nm = '200812_ma_invertible.md'
    art_nm = '200814_ar_charac.md'
    art_nm = '200904_stan_gamma_1.md'

    path_art = os.path.join('text', art_nm)
    path_art_cnvd = os.path.join('text', 'new_' + art_nm)

    # Load a article to be replaced
    with open(path_art, 'r') as f:
        artile_strings = f.read()

    rht = ConvertHatenaTex()
    artile_strings_new = rht.replace(artile_strings)

    # Save the replaced article
    with open(path_art_cnvd, 'w') as f:
        f.write(artile_strings_new)
