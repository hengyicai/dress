require '.'
require 'shortcut'
require 'sampleA_RF'
require 'post_processing_unk'

local function main()
    local cmd = torch.CmdLine()
    cmd:text('Options for generate raw output:')
    cmd:option('--modelPath', '', 'model path')
    cmd:option('--modelStatePath', '', 'model State path')
    cmd:option('--lmPath', '', 'language model path')
    cmd:option('--lmWeight', 0.5, 'language model weight during decoding')
    cmd:option('--lexTransPath', '', 'lex translation path')
    cmd:option('--lexTransWeight', 0.2, 'lex translation weight')
    cmd:option('--lexSelfDiscount', 0.5, 'discount for self translation')
    cmd:option('--dataPath', '', 'input data path')
    cmd:option('--outPath', '', 'output path')
    --    cmd:option('--outPathRaw',
    --        '/disk/scratch/XingxingZhang/encdec/sent_simple/encdec_attention_PWKP_margin_prob/sampleA/model_0.001.256.dot.2L.adam.reload.sgd.m0.97.valid',
    --        'raw output path. Note the current output is without UNK replacement and NER recovery')
    --    cmd:option('--oriDataPath',
    --        '/afs/inf.ed.ac.uk/group/project/img2txt/encdec/dataset/PWKP/an_ner/PWKP_108016.tag.80.aner.ori.valid',
    --        'original data path without ner replacement')
    cmd:option('--oriMapPath',
        '/root/caihengyi/workspace/dress/pre-trained-models/wiki.full.aner.map.t7',
        'map between NER and original text')

    local opts = cmd:parse(arg)

    --    -- generate raw output by sampling (the output without UNK replacement and NER recovery)
    --    local sampler = EncDecASampler(opts.modelPath, opts.modelStatePath, opts.lmPath, opts.lmWeight,
    --        opts.lexTransPath, opts.lexTransWeight, opts.lexSelfDiscount)
    --    -- local sampler = EncDecASampler(opts.modelPath, opts.lmPath)
    --    sampler:generateBatch(opts.dataPath, opts.outPath)

    local att_file = opts.outPath .. '.att.t7'
    local unk_rep_file = opts.outPath .. '.unk.rep.txt'
    local ner_src_file = opts.dataPath
    PostProcessorUnk.replaceUnk(ner_src_file, opts.outPath, att_file, unk_rep_file)

    local out_file = opts.outPath .. '.out.txt'
    --    local ref_file = opts.oriDataPath .. '.dst'
    PostProcessorUnk.recoverNER(ner_src_file, unk_rep_file, opts.oriMapPath, out_file)
    --
    --    -- local cmd = string.format('./scripts/multi-bleu.perl %s < %s', ref_file, out_file)
    --    -- os.execute(cmd)
    --
    --    local src_file = opts.oriDataPath .. '.src'
    --    local bleu_eval = require 'bleu_eval'
    --    local bleu = bleu_eval.eval(src_file, ref_file, out_file)
    --    printf('bleu = %f\n', bleu)
    --
    --    require 'SARI'
    --    local sari = SARI.SARIfile(src_file, out_file, ref_file)
    --    printf('SARI = %f\n', sari)
    --
    --    local fkgl_eval = require 'fkgl_eval'
    --    local fkgl = fkgl_eval.eval(out_file)
    --    printf('FKGL = %f\n', fkgl)
    --
    --    PostProcessorUnk.compareOri(src_file, out_file)
    --
    --    local analyze_results = require 'analyze_results'
    --    local ana_file = opts.outPathRaw .. '.ana.txt'
    --    analyze_results.analyze(src_file, ref_file, out_file, ana_file)
    --    printf('analyze file save at %s\n', ana_file)
end

main()


